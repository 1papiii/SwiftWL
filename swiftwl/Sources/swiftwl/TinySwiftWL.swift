import wayland
import Glibc
import wayland_swift

let openRestrictedTrampoline: @convention(c) (UnsafePointer<CChar>?, Int32, UnsafeMutableRawPointer?) -> Int32 = { path, flags, user_data in
    guard let path = path else { return -1 }
    return open(path, flags)
}

let closeRestrictedTrampoline: @convention(c) (Int32, UnsafeMutableRawPointer?) -> Void = { fd, user_data in
    close(fd)
}

nonisolated(unsafe) let libinputInterface = libinput_interface(
    open_restricted: openRestrictedTrampoline,
    close_restricted: closeRestrictedTrampoline
)

final class SurfaceState {
    var frameCallback: UInt32? = nil
}

final class ServerState {
    let display: OpaquePointer
    let xkbContext: XkbContext
    let xkbKeymap: XkbKeymap
    let keymapString: String
    let keymapFd: Int32
    let keymapSize: Int32
    let keycodeOffset: UInt32
    let xkbState: XkbState
    let liPtr: OpaquePointer

    var keyboardResource: UnsafeMutablePointer<wl_resource>? = nil
    var focusedSurface: UnsafeMutablePointer<wl_resource>? = nil
    var previousMods: (depressed: UInt32, latched: UInt32, locked: UInt32, group: UInt32)? = nil

    let mod4Index: UInt32
    let shiftIndex: UInt32

    init(display: OpaquePointer) {
        self.display = display
        self.xkbContext = XkbContext()
        self.xkbKeymap = xkbContext.keymapFromNames()!
        self.keymapString = xkbKeymap.getAsString()!
        let (fd, size) = createKeymapFile(keymapString)!
        self.keymapFd = fd
        self.keymapSize = size
        self.keycodeOffset = xkbKeymap.keycodeOffset
        self.xkbState = xkbKeymap.createState()
        self.mod4Index = xkbKeymap.modGetIndex("Mod4")
        self.shiftIndex = xkbKeymap.modGetIndex("Shift")
        guard let udev = udev_new() else { fatalError("udev_new() failed") }
        guard let li = withUnsafePointer(to: libinputInterface, { ptr in
            libinput_udev_create_context(ptr, nil, udev)
        }) else { fatalError("libinput_udev_create_context() failed") }
        self.liPtr = li
    }
    deinit {
        close(keymapFd)
        libinput_unref(liPtr)
    }

    func terminateDisplay() {
        wl_display_terminate(display)
    }
}

let libinputTrampoline: @convention(c) (Int32, UInt32, UnsafeMutableRawPointer?) -> Int32 = { fd, mask, data in
    guard let data = data else { return 0 }
    let state = Unmanaged<ServerState>.fromOpaque(data).takeUnretainedValue()
    libinput_dispatch(state.liPtr)
    while true {
        guard let event = libinput_get_event(state.liPtr) else { break }
        defer { libinput_event_destroy(event) }
        let eventType = libinput_event_get_type(event)
        if eventType == LIBINPUT_EVENT_KEYBOARD_KEY {
            guard let kbEvent = libinput_event_get_keyboard_event(event) else { continue }
            let keycode = UInt32(libinput_event_keyboard_get_key(kbEvent))
            let keyState = libinput_event_keyboard_get_key_state(kbEvent)
            let pressed = keyState == LIBINPUT_KEY_STATE_PRESSED
            handleKey(state: state, keycode: keycode, pressed: pressed)
        }
    }
    wl_display_flush_clients(state.display)
    return 0
}

private func handleKeybinding(state: ServerState, sym: UInt32) -> Bool {
    switch sym {
    case UInt32(XKB_KEY_Escape):
        state.terminateDisplay()
        return true
    case UInt32(XKB_KEY_q), UInt32(XKB_KEY_Q):
        let shiftHeld = state.xkbState.modIndexActive(
            idx: state.shiftIndex, component: XKB_STATE_MODS_DEPRESSED)
        if shiftHeld {
            state.terminateDisplay()
            return true
        }
        return false
    default:
        return false
    }
}

private func handleKey(state: ServerState, keycode: UInt32, pressed: Bool) {
    let xkbKeycode = keycode + UInt32(state.keycodeOffset)
    state.xkbState.updateKey(key: xkbKeycode, pressed: pressed)

    if pressed {
        let sym = state.xkbState.keyGetSym(keycode: xkbKeycode)
        let mod4Held = state.xkbState.modIndexActive(
            idx: state.mod4Index, component: XKB_STATE_MODS_DEPRESSED)
        if mod4Held {
            if handleKeybinding(state: state, sym: sym) {
                return
            }
        }
    }

    guard let kbResource = state.keyboardResource else { return }
    let serial = wl_display_next_serial(state.display)
    let wlState: UInt32 = pressed ? 1 : 0
    wl_keyboard_send_key(kbResource, serial, 0, xkbKeycode, wlState)

    let mods = state.xkbState.serializedMods()
    let prevMods = state.previousMods
    if prevMods == nil ||
       prevMods!.depressed != mods.depressed ||
       prevMods!.latched != mods.latched ||
       prevMods!.locked != mods.locked ||
       prevMods!.group != mods.group {
        wl_keyboard_send_modifiers(kbResource, serial, mods.depressed, mods.latched, mods.locked, mods.group)
        state.previousMods = mods
    }
}

let compositorBindTrampoline: @convention(c) (OpaquePointer?, UnsafeMutableRawPointer?, UInt32, UInt32) -> Void = { client, data, version, id in
    guard let client = client else { return }
    guard let resource = wl_resource_create(client, wl_swift_compositor_interface(), Int32(version), id) else { return }
    let env = UnsafeMutablePointer<wl_swift_compositor_env>.allocate(capacity: 1)
    env.pointee = wl_swift_compositor_env(
        swift_context: data,
        create_surface: compositorCreateSurfaceTrampoline,
        create_region: compositorCreateRegionTrampoline,
        release: compositorReleaseTrampoline
    )
    wl_swift_set_compositor_implementation(resource, env)
}

let compositorCreateSurfaceTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void = { ctx, client, _, id in
    guard let client = client else { return }
    guard let surfaceWl = wl_resource_create(client, wl_swift_surface_interface(), 1, id) else { return }
    let surfaceState = SurfaceState()
    let env = UnsafeMutablePointer<wl_swift_surface_env>.allocate(capacity: 1)
    env.pointee = wl_swift_surface_env(
        swift_context: ctx,
        state: Unmanaged.passUnretained(surfaceState).toOpaque(),
        destroy: nil, attach: nil, damage: nil,
        frame: surfaceFrameTrampoline,
        set_opaque_region: nil, set_input_region: nil,
        commit: surfaceCommitTrampoline,
        set_buffer_transform: nil, set_buffer_scale: nil,
        damage_buffer: nil, offset: nil
    )
    wl_swift_set_surface_implementation(surfaceWl, env)

    let serverState = Unmanaged<ServerState>.fromOpaque(ctx!).takeUnretainedValue()
    let serial = wl_display_next_serial(serverState.display)
    if let oldFocus = serverState.focusedSurface, let kbRes = serverState.keyboardResource {
        wl_keyboard_send_leave(kbRes, serial, oldFocus)
    }
    serverState.focusedSurface = surfaceWl
    if let kbRes = serverState.keyboardResource {
        var emptyKeys = wl_array()
        wl_keyboard_send_enter(kbRes, serial, surfaceWl, &emptyKeys)
    }
}

let compositorCreateRegionTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void = { _, _, _, _ in }
let compositorReleaseTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?) -> Void = { _, _, _ in }

let surfaceFrameTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void = { _, statePtr, _, resource, callback in
    guard let statePtr = statePtr else { return }
    let s = Unmanaged<SurfaceState>.fromOpaque(statePtr).takeUnretainedValue()
    s.frameCallback = callback
}

let surfaceCommitTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?) -> Void = { _, statePtr, _, resource in
    guard let resource = resource, let statePtr = statePtr else { return }
    let s = Unmanaged<SurfaceState>.fromOpaque(statePtr).takeUnretainedValue()
    if let cb = s.frameCallback {
        let callbackResource = wl_client_get_object(wl_resource_get_client(resource), cb)
        if let callbackResource = callbackResource {
            wl_callback_send_done(callbackResource, 0)
        }
        s.frameCallback = nil
    }
}

let shmBindTrampoline: @convention(c) (OpaquePointer?, UnsafeMutableRawPointer?, UInt32, UInt32) -> Void = { client, data, version, id in
    guard let client = client else { return }
    guard let resource = wl_resource_create(client, wl_swift_shm_interface(), 1, id) else { return }
    wl_shm_send_format(resource, 1)
    let env = UnsafeMutablePointer<wl_swift_shm_env>.allocate(capacity: 1)
    env.pointee = wl_swift_shm_env(
        swift_context: data, state: nil,
        create_pool: shmCreatePoolTrampoline, release: nil
    )
    wl_swift_set_shm_implementation(resource, env)
}

let shmCreatePoolTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32, Int32, Int32) -> Void = { ctx, _, client, resource, id, fd, size in
    guard let client = client else { return }
    guard let poolWl = wl_resource_create(client, wl_swift_shm_pool_interface(), 1, id) else { return }
    let env = UnsafeMutablePointer<wl_swift_shm_pool_env>.allocate(capacity: 1)
    env.pointee = wl_swift_shm_pool_env(
        swift_context: ctx, state: nil,
        create_buffer: shmPoolCreateBufferTrampoline,
        destroy: nil, resize: nil
    )
    wl_swift_set_shm_pool_implementation(poolWl, env)
    close(fd)
}

let shmPoolCreateBufferTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32, Int32, Int32, Int32, Int32, UInt32) -> Void = { _, _, client, _, id, _, _, _, _, _ in
    guard let client = client else { return }
    guard let bufferWl = wl_resource_create(client, wl_swift_buffer_interface(), 1, id) else { return }
    wl_swift_set_buffer_implementation(bufferWl)
}

let seatBindTrampoline: @convention(c) (OpaquePointer?, UnsafeMutableRawPointer?, UInt32, UInt32) -> Void = { client, data, version, id in
    guard let client = client else { return }
    guard let resource = wl_resource_create(client, wl_swift_seat_interface(), 1, id) else { return }
    wl_seat_send_capabilities(resource, UInt32(WL_SEAT_CAPABILITY_POINTER.rawValue | WL_SEAT_CAPABILITY_KEYBOARD.rawValue))
    "tinyswiftwl-seat-0".withCString { wl_seat_send_name(resource, $0) }
    let env = UnsafeMutablePointer<wl_swift_seat_env>.allocate(capacity: 1)
    env.pointee = wl_swift_seat_env(
        swift_context: data, state: nil,
        get_pointer: nil,
        get_keyboard: seatGetKeyboardTrampoline,
        get_touch: nil, release: nil
    )
    wl_swift_set_seat_implementation(resource, env)
}

let seatGetKeyboardTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void = { ctx, _, client, seatResource, id in
    guard let client = client else { return }
    guard let keyboardWl = wl_resource_create(client, wl_swift_keyboard_interface(), 1, id) else { return }
    let statePtr = Unmanaged<ServerState>.fromOpaque(ctx!).takeUnretainedValue()
    statePtr.keyboardResource = keyboardWl
    wl_keyboard_send_keymap(keyboardWl, 1, statePtr.keymapFd, UInt32(statePtr.keymapSize))
    lseek(statePtr.keymapFd, 0, SEEK_SET)
    let env = UnsafeMutablePointer<wl_swift_keyboard_env>.allocate(capacity: 1)
    env.pointee = wl_swift_keyboard_env(
        swift_context: ctx, state: nil, release: nil
    )
    wl_swift_set_keyboard_implementation(keyboardWl, env)
}

@main
struct TinySwiftWL {
    static func main() {
        guard let display = wl_display_create() else {
            fatalError("wl_display_create() failed")
        }
        defer { wl_display_destroy(display) }

        guard let socket = wl_display_add_socket_auto(display) else {
            fatalError("wl_display_add_socket_auto() failed")
        }
        print("TinySwiftWL: running on Wayland socket '\(String(cString: socket))'")
        print("TinySwiftWL: connect with: WAYLAND_DISPLAY=\(String(cString: socket)) <any wayland client>")

        let state = ServerState(display: display)

        guard let _ = wl_global_create(
            display, wl_swift_compositor_interface(), 1,
            Unmanaged.passUnretained(state).toOpaque(),
            compositorBindTrampoline
        ) else { fatalError("wl_global_create(compositor) failed") }

        guard let _ = wl_global_create(
            display, wl_swift_shm_interface(), 1,
            Unmanaged.passUnretained(state).toOpaque(),
            shmBindTrampoline
        ) else { fatalError("wl_global_create(shm) failed") }

        guard let _ = wl_global_create(
            display, wl_swift_seat_interface(), 1,
            Unmanaged.passUnretained(state).toOpaque(),
            seatBindTrampoline
        ) else { fatalError("wl_global_create(seat) failed") }

        "seat0".withCString { ptr in
            if libinput_udev_assign_seat(state.liPtr, ptr) < 0 {
                print("TinySwiftWL: warning: libinput_udev_assign_seat failed")
            }
        }

        let liFd = libinput_get_fd(state.liPtr)
        guard liFd >= 0 else { fatalError("libinput_get_fd failed") }
        let loop = wl_display_get_event_loop(display)!
        let dataPtr = Unmanaged.passUnretained(state).toOpaque()
        if wl_event_loop_add_fd(loop, liFd, WlEventMask.readable, libinputTrampoline, dataPtr) == nil {
            print("TinySwiftWL: warning: could not add libinput fd to event loop")
        }

        wl_display_run(display)
        print("TinySwiftWL: exiting")
    }
}
