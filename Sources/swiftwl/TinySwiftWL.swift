import wayland
import Glibc
import wayland_swift

struct InputEvent {
    let sec: Int
    let usec: Int
    let type: UInt16
    let code: UInt16
    let value: Int32
}

private let EVIOCGRAB: UInt = 0x40044590
private let EV_KEY: UInt16 = 0x01
private let EV_SYN: UInt16 = 0x00

func findKeyboardDevice() -> String? {
    let commonPaths = [
        "/dev/input/by-path/platform-i8042-serio-0-event-kbd",
        "/dev/input/by-path/platform-i8042-serio-1-event-kbd",
        "/dev/input/by-path/platform-i8042-serio-event-kbd",
    ]
    for path in commonPaths {
        if access(path, R_OK) == 0 { return path }
    }
    guard let dir = opendir("/dev/input/by-path") else { return nil }
    defer { closedir(dir) }
    while let entry = readdir(dir) {
        let name = withUnsafePointer(to: entry.pointee.d_name) { ptr in
            String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
        }
        if name.hasSuffix("-kbd") {
            return "/dev/input/by-path/" + name
        }
    }
    return nil
}

func openKeyboardDevice(path: String) -> Int32? {
    let fd = open(path, O_RDWR)
    guard fd >= 0 else { return nil }
    var grab: Int32 = 1
    _ = ioctl(fd, EVIOCGRAB, &grab)
    let flags = fcntl(fd, F_GETFL)
    _ = fcntl(fd, F_SETFL, flags | O_NONBLOCK)
    return fd
}

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
    }
    deinit {
        close(keymapFd)
    }

    func terminateDisplay() {
        wl_display_terminate(display)
    }
}

let keyboardInputTrampoline: @convention(c) (Int32, UInt32, UnsafeMutableRawPointer?) -> Int32 = { fd, mask, data in
    guard let data = data else { return 0 }
    let state = Unmanaged<ServerState>.fromOpaque(data).takeUnretainedValue()
    var ev = InputEvent(sec: 0, usec: 0, type: 0, code: 0, value: 0)
    while true {
        let n = read(fd, &ev, MemoryLayout<InputEvent>.size)
        if n != MemoryLayout<InputEvent>.size { break }
        if ev.type == EV_KEY {
            handleKeyEvent(state: state, ev: ev)
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
    default:
        return false
    }
}

private func handleKeyEvent(state: ServerState, ev: InputEvent) {
    let pressed = ev.value == 1 || ev.value == 2
    let xkbKeycode = UInt32(ev.code) + state.keycodeOffset
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
    let time = UInt32(ev.sec * 1000 + ev.usec / 1000)
    let wlState: UInt32 = pressed ? 1 : 0
    wl_keyboard_send_key(kbResource, serial, time, xkbKeycode, wlState)

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
    let state = SurfaceState()
    let env = UnsafeMutablePointer<wl_swift_surface_env>.allocate(capacity: 1)
    env.pointee = wl_swift_surface_env(
        swift_context: ctx,
        state: Unmanaged.passUnretained(state).toOpaque(),
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
    let state = Unmanaged<SurfaceState>.fromOpaque(statePtr).takeUnretainedValue()
    state.frameCallback = callback
}

let surfaceCommitTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?) -> Void = { _, statePtr, _, resource in
    guard let resource = resource, let statePtr = statePtr else { return }
    let state = Unmanaged<SurfaceState>.fromOpaque(statePtr).takeUnretainedValue()
    if let cb = state.frameCallback {
        let callbackResource = wl_client_get_object(wl_resource_get_client(resource), cb)
        if let callbackResource = callbackResource {
            wl_callback_send_done(callbackResource, 0)
        }
        state.frameCallback = nil
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
        print("TinySwiftWL running on Wayland socket '\(String(cString: socket))'")
        print("TinySwiftWL connect with: WAYLAND_DISPLAY=\(String(cString: socket)) <any wayland client>")

        let state = ServerState(display: display)

        guard let _ = wl_global_create(
            display, wl_swift_compositor_interface(), 1,
            Unmanaged.passUnretained(state).toOpaque(),
            compositorBindTrampoline
        ) else {
            fatalError("wl_global_create(compositor) failed")
        }

        guard let _ = wl_global_create(
            display, wl_swift_shm_interface(), 1,
            Unmanaged.passUnretained(state).toOpaque(),
            shmBindTrampoline
        ) else {
            fatalError("wl_global_create(shm) failed")
        }

        guard let _ = wl_global_create(
            display, wl_swift_seat_interface(), 1,
            Unmanaged.passUnretained(state).toOpaque(),
            seatBindTrampoline
        ) else {
            fatalError("wl_global_create(seat) failed")
        }

        if let kbdPath = findKeyboardDevice() {
            if let kbdFd = openKeyboardDevice(path: kbdPath) {
                print("TinySwiftWL: keyboard device: \(kbdPath)")
                let loop = wl_display_get_event_loop(display)!
                let dataPtr = Unmanaged.passUnretained(state).toOpaque()
                if wl_event_loop_add_fd(loop, kbdFd, WlEventMask.readable, keyboardInputTrampoline, dataPtr) == nil {
                    print("TinySwiftWL: warning: could not add keyboard fd to event loop")
                    close(kbdFd)
                }
            } else {
                print("TinySwiftWL: warning: could not open keyboard device \(kbdPath)")
            }
        } else {
            print("TinySwiftWL: warning: no keyboard device found; input disabled")
        }

        wl_display_run(display)
        print("TinySwiftWL: exiting")
    }
}
