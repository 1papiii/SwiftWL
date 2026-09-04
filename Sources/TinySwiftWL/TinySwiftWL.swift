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

private let EV_KEY: UInt16 = 0x01
private let EV_SYN: UInt16 = 0x00

func findKeyboardPaths() -> [String] {
    let commonPaths = [
        "/dev/input/by-path/platform-i8042-serio-0-event-kbd",
        "/dev/input/by-path/platform-i8042-serio-1-event-kbd",
        "/dev/input/by-path/platform-i8042-serio-event-kbd",
    ]
    var results: [String] = []
    for path in commonPaths {
        if access(path, R_OK) == 0 {
            results.append(path)
        }
    }
    guard let dir = opendir("/dev/input/by-path") else { return results }
    defer { closedir(dir) }
    while let entry = readdir(dir) {
        let name = withUnsafePointer(to: entry.pointee.d_name) { ptr in
            String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
        }
        if name.hasSuffix("-kbd") {
            let fullPath = "/dev/input/by-path/" + name
            if !results.contains(fullPath) {
                results.append(fullPath)
            }
        }
    }
    return results
}

final class SurfaceState {
    var frameCallback: UInt32? = nil
}

final class Seat {
    let display: OpaquePointer
    let loop: OpaquePointer

    let xkbContext: XkbContext
    let xkbKeymap: XkbKeymap
    let keymapString: String
    let keymapFd: Int32
    let keymapSize: Int32
    let keycodeOffset: UInt32
    let xkbState: XkbState

    var seatResource: WlSeatResource? = nil
    var keyboardResources: [WlKeyboardResource] = []

    var focusedSurface: UnsafeMutablePointer<wl_resource>? = nil
    var previousMods: (depressed: UInt32, latched: UInt32, locked: UInt32, group: UInt32)? = nil

    let mod4Index: UInt32
    let shiftIndex: UInt32

    var libSeat: LibSeat? = nil
    var openDevices: [LibSeatDevice] = []
    var keyboardEventSources: [OpaquePointer?] = []

    init(display: OpaquePointer, loop: OpaquePointer) {
        self.display = display
        self.loop = loop
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

    func handleKeybinding(sym: UInt32) -> Bool {
        switch sym {
        case UInt32(XKB_KEY_Escape):
            terminateDisplay()
            return true
        default:
            return false
        }
    }

    func handleKeyEvent(ev: InputEvent) {
        let pressed = ev.value == 1 || ev.value == 2
        let xkbKeycode = UInt32(ev.code) + keycodeOffset
        xkbState.updateKey(key: xkbKeycode, pressed: pressed)

        if pressed {
            let sym = xkbState.keyGetSym(keycode: xkbKeycode)
            let mod4Held = xkbState.modIndexActive(
                idx: mod4Index, component: XKB_STATE_MODS_DEPRESSED)
            if mod4Held, handleKeybinding(sym: sym) {
                return
            }
        }

        let serial = wl_display_next_serial(display)
        let time = UInt32(ev.sec * 1000 + ev.usec / 1000)
        let wlState: UInt32 = pressed ? 1 : 0
        let keycode = xkbKeycode

        for kb in keyboardResources {
            if pressed { kb.keyPressed(keycode) }
            else { kb.keyReleased(keycode) }
            kb.sendKey(serial: serial, time: time, key: keycode, state: wlState)
        }

        let mods = xkbState.serializedMods()
        let prevMods = previousMods
        if prevMods == nil ||
           prevMods!.depressed != mods.depressed ||
           prevMods!.latched != mods.latched ||
           prevMods!.locked != mods.locked ||
           prevMods!.group != mods.group {
            for kb in keyboardResources {
                kb.sendModifiers(serial: serial, depressed: mods.depressed, latched: mods.latched, locked: mods.locked, group: mods.group)
            }
            previousMods = mods
        }
    }

    func setFocusedSurface(_ surface: UnsafeMutablePointer<wl_resource>?) {
        let serial = wl_display_next_serial(display)
        if let oldFocus = focusedSurface {
            for kb in keyboardResources {
                kb.sendLeave(serial: serial, surface: oldFocus)
            }
        }
        focusedSurface = surface
        if let surface = surface {
            for kb in keyboardResources {
                kb.sendEnter(serial: serial, surface: surface, keys: Array(kb.pressedKeys))
            }
        }
    }

    func openKeyboardDevices() {
        guard let libSeat = libSeat else {
            let paths = findKeyboardPaths()
            let dataPtr = Unmanaged.passUnretained(self).toOpaque()
            for path in paths {
                let fd = open(path, O_RDWR | O_NONBLOCK)
                guard fd >= 0 else { continue }
                print("TinySwiftWL: opened keyboard device: \(path)")
                if let source = wl_event_loop_add_fd(loop, fd, WlEventMask.readable, keyboardInputTrampoline, dataPtr) {
                    openDevices.append(LibSeatDevice(deviceId: -1, fd: fd, path: path))
                    keyboardEventSources.append(source)
                } else {
                    close(fd)
                }
            }
            if paths.isEmpty { print("TinySwiftWL: no keyboard devices found; input disabled") }
            return
        }
        let paths = findKeyboardPaths()
        if paths.isEmpty { print("TinySwiftWL: no keyboard devices found"); return }
        let dataPtr = Unmanaged.passUnretained(self).toOpaque()
        for path in paths {
            guard let device = libSeat.openDevice(path: path) else { continue }
            print("TinySwiftWL: opened keyboard device: \(path) (deviceId=\(device.deviceId))")
            let flags = fcntl(device.fd, F_GETFL)
            _ = fcntl(device.fd, F_SETFL, flags | O_NONBLOCK)
            if let source = wl_event_loop_add_fd(loop, device.fd, WlEventMask.readable, keyboardInputTrampoline, dataPtr) {
                openDevices.append(device)
                keyboardEventSources.append(source)
            } else {
                libSeat.closeDevice(device)
            }
        }
    }

    func closeKeyboardDevices() {
        if let libSeat = libSeat {
            for device in openDevices { libSeat.closeDevice(device) }
        } else {
            for device in openDevices { close(device.fd) }
        }
        openDevices.removeAll()
        keyboardEventSources.removeAll()
    }
}

let keyboardInputTrampoline: @convention(c) (Int32, UInt32, UnsafeMutableRawPointer?) -> Int32 = { fd, mask, data in
    guard let data = data else { return 0 }
    let seat = Unmanaged<Seat>.fromOpaque(data).takeUnretainedValue()
    var ev = InputEvent(sec: 0, usec: 0, type: 0, code: 0, value: 0)
    while true {
        let n = read(fd, &ev, MemoryLayout<InputEvent>.size)
        if n != MemoryLayout<InputEvent>.size { break }
        if ev.type == EV_KEY {
            seat.handleKeyEvent(ev: ev)
        }
    }
    wl_display_flush_clients(seat.display)
    return 0
}

let libseatDispatchTrampoline: @convention(c) (Int32, UInt32, UnsafeMutableRawPointer?) -> Int32 = { _, _, data in
    guard let data = data else { return 0 }
    let seat = Unmanaged<Seat>.fromOpaque(data).takeUnretainedValue()
    if let libSeat = seat.libSeat {
        _ = libSeat.dispatch(timeout: 0)
    }
    wl_display_flush_clients(seat.display)
    return 0
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
        state: Unmanaged.passRetained(state).toOpaque(),
        destroy: surfaceDestroyTrampoline, attach: nil, damage: nil,
        frame: surfaceFrameTrampoline,
        set_opaque_region: nil, set_input_region: nil,
        commit: surfaceCommitTrampoline,
        set_buffer_transform: nil, set_buffer_scale: nil,
        damage_buffer: nil, offset: nil
    )
    wl_swift_set_surface_implementation(surfaceWl, env)

    let seat = Unmanaged<Seat>.fromOpaque(ctx!).takeUnretainedValue()
    seat.setFocusedSurface(surfaceWl)
}

let compositorCreateRegionTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void = { _, _, _, _ in }
let compositorReleaseTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?) -> Void = { _, _, _ in }

let surfaceFrameTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void = { _, statePtr, _, resource, callback in
    guard let statePtr = statePtr else { return }
    let state = Unmanaged<SurfaceState>.fromOpaque(statePtr).takeUnretainedValue()
    state.frameCallback = callback
}

let surfaceDestroyTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?) -> Void = { ctx, statePtr, _, _ in
    guard let statePtr = statePtr else { return }
    Unmanaged<SurfaceState>.fromOpaque(statePtr).release()
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
    wl_shm_send_format(resource, 0)
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
    guard let resource = wl_resource_create(client, wl_swift_seat_interface(), 7, id) else { return }
    let seat = Unmanaged<Seat>.fromOpaque(data!).takeUnretainedValue()

    let caps = UInt32(WL_SEAT_CAPABILITY_KEYBOARD.rawValue)
    let seatRes = WlSeatResource(resource: resource, name: "tinyswiftwl-seat-0", capabilities: caps)
    seat.seatResource = seatRes

    let env = UnsafeMutablePointer<wl_swift_seat_env>.allocate(capacity: 1)
    env.pointee = wl_swift_seat_env(
        swift_context: data,
        state: Unmanaged.passUnretained(seatRes).toOpaque(),
        get_pointer: seatGetPointerTrampoline,
        get_keyboard: seatGetKeyboardTrampoline,
        get_touch: seatGetTouchTrampoline,
        release: nil
    )
    wl_swift_set_seat_implementation(resource, env)
}

let seatGetPointerTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void = { ctx, seatResCtx, client, seatResource, id in
    guard let client = client, let ctx = ctx else { return }
    let seat = Unmanaged<Seat>.fromOpaque(ctx).takeUnretainedValue()
    seat.seatResource?.createPointer(client: client, id: id)
}

let seatGetKeyboardTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void = { ctx, seatResCtx, client, seatResource, id in
    guard let client = client, let ctx = ctx else { return }
    let seat = Unmanaged<Seat>.fromOpaque(ctx).takeUnretainedValue()
    guard let seatRes = seat.seatResource else { return }

    let kb = seatRes.createKeyboard(
        client: client, id: id,
        keymapFd: seat.keymapFd,
        keymapSize: UInt32(seat.keymapSize)
    )
    lseek(seat.keymapFd, 0, SEEK_SET)
    seat.keyboardResources.append(kb)

    if let surface = seat.focusedSurface {
        let serial = wl_display_next_serial(seat.display)
        kb.sendEnter(serial: serial, surface: surface, keys: Array(kb.pressedKeys))
    }
}

let seatGetTouchTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void = { ctx, seatResCtx, client, seatResource, id in
    guard let client = client, let ctx = ctx else { return }
    let seat = Unmanaged<Seat>.fromOpaque(ctx).takeUnretainedValue()
    seat.seatResource?.createTouch(client: client, id: id)
}
let outputBindTrampoline: @convention(c) (OpaquePointer?, UnsafeMutableRawPointer?, UInt32, UInt32) -> Void = { client, data, version, id in
    guard let client = client else { return }
    guard let resource = wl_resource_create(client, wl_swift_output_interface(), 2, id) else { return }

    "Virtual".withCString { make in
        "Monitor".withCString { model in
            wl_output_send_geometry(resource, 0, 0, 1024, 768, Int32(WL_OUTPUT_SUBPIXEL_UNKNOWN.rawValue), make, model, Int32(WL_OUTPUT_TRANSFORM_NORMAL.rawValue))
        }
    }

    wl_output_send_mode(resource, WL_OUTPUT_MODE_CURRENT.rawValue | WL_OUTPUT_MODE_PREFERRED.rawValue, 1280, 720, 60000)

    wl_output_send_scale(resource, 1)

    "Virtual-1".withCString { wl_output_send_name(resource, $0) }
    "TinySwiftWL Virtual Output".withCString { wl_output_send_description(resource, $0) }
}
let xdgWmBaseBindTrampoline: @convention(c) (OpaquePointer?, UnsafeMutableRawPointer?, UInt32, UInt32) -> Void = { client, data, version, id in
    guard let client = client else { return }
    guard let resource = wl_resource_create(client, wl_swift_xdg_wm_base_interface(), Int32(version), id) else { return }
    let env = UnsafeMutablePointer<wl_swift_xdg_wm_base_env>.allocate(capacity: 1)
    env.pointee = wl_swift_xdg_wm_base_env(
        swift_context: data, state: nil,
        destroy: nil,
        create_positioner: nil,
        get_xdg_surface: unsafeBitCast(xdgGetXdgSurfaceTrampoline, to: UnsafeMutableRawPointer.self),
        pong: unsafeBitCast(xdgPongTrampoline, to: UnsafeMutableRawPointer.self)
    )
    wl_swift_set_xdg_wm_base_implementation(resource, env)
}

let xdgGetXdgSurfaceTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32, UnsafeMutablePointer<wl_resource>?) -> Void = { ctx, _, client, resource, id, surface in
    guard let client = client else { return }
    guard let xdgSurfaceWl = wl_resource_create(client, wl_swift_xdg_surface_interface(), 1, id) else { return }
    print("TinySwiftWL: xdg_surface created (id=\(id))")

    let env = UnsafeMutablePointer<wl_swift_xdg_surface_env>.allocate(capacity: 1)
    env.pointee = wl_swift_xdg_surface_env(
        swift_context: ctx, state: nil,
        destroy: nil,
        get_toplevel: unsafeBitCast(xdgGetToplevelTrampoline, to: UnsafeMutableRawPointer.self),
        get_popup: nil,
        set_window_geometry: nil,
        ack_configure: nil
    )
    wl_swift_set_xdg_surface_implementation(xdgSurfaceWl, env)

    let serial = wl_display_next_serial(wl_client_get_display(client))
    wl_swift_xdg_surface_send_configure(xdgSurfaceWl, serial)
}

let xdgGetToplevelTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void = { ctx, _, client, resource, id in
    guard let client = client else { return }
    guard let toplevelWl = wl_resource_create(client, wl_swift_xdg_toplevel_interface(), 1, id) else { return }
    print("TinySwiftWL: xdg_toplevel created (id=\(id))")

    let env = UnsafeMutablePointer<wl_swift_xdg_toplevel_env>.allocate(capacity: 1)
    env.pointee = wl_swift_xdg_toplevel_env(
        swift_context: ctx, state: nil,
        destroy: nil,
        set_parent: nil,
        set_title: unsafeBitCast(xdgSetTitleTrampoline, to: UnsafeMutableRawPointer.self),
        set_app_id: unsafeBitCast(xdgSetAppIdTrampoline, to: UnsafeMutableRawPointer.self),
        show_window_menu: nil,
        move: nil,
        resize: nil,
        set_max_size: nil,
        set_min_size: nil,
        set_maximized: nil,
        unset_maximized: nil,
        set_fullscreen: nil,
        unset_fullscreen: nil,
        set_minimized: nil
    )
    wl_swift_set_xdg_toplevel_implementation(toplevelWl, env)

    var states = wl_array()
    wl_swift_xdg_toplevel_send_configure(toplevelWl, 800, 600, &states)
}

let xdgSetTitleTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UnsafePointer<CChar>?) -> Void = { _, _, _, _, title in
    guard let title = title else { return }
    print("TinySwiftWL: set_title: \(String(cString: title))")
}

let xdgSetAppIdTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UnsafePointer<CChar>?) -> Void = { _, _, _, _, appId in
    guard let appId = appId else { return }
    print("TinySwiftWL: set_app_id: \(String(cString: appId))")
}

let xdgPongTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void = { _, _, _, _, serial in
    print("TinySwiftWL: pong serial=\(serial)")
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

        let loop = wl_display_get_event_loop(display)!
        let seat = Seat(display: display, loop: loop)
        let dataPtr = Unmanaged.passUnretained(seat).toOpaque()

        guard let _ = wl_global_create(
            display, wl_swift_compositor_interface(), 1,
            dataPtr,
            compositorBindTrampoline
        ) else {
            fatalError("wl_global_create(compositor) failed")
        }

        guard let _ = wl_global_create(
            display, wl_swift_shm_interface(), 1,
            dataPtr,
            shmBindTrampoline
        ) else {
            fatalError("wl_global_create(shm) failed")
        }

        guard let _ = wl_global_create(
            display, wl_swift_seat_interface(), 7,
            dataPtr,
            seatBindTrampoline
        ) else {
            fatalError("wl_global_create(seat) failed")
        }

        guard let _ = wl_global_create(
            display, wl_swift_xdg_wm_base_interface(), 7,
            dataPtr,
            xdgWmBaseBindTrampoline
        ) else {
            fatalError("wl_global_create(xdg_wm_base) failed")
        }
        print("TinySwiftWL: xdg_wm_base global registered (version 7)")

        guard let _ = wl_global_create(
            display, wl_swift_output_interface(), 2,
            nil,
            outputBindTrampoline
        ) else {
            fatalError("wl_global_create(output) failed")
        }
        print("TinySwiftWL: wl_output global registered (version 2)")

        let libSeat = LibSeat.make(listener: LibSeatListenerHandlers(
            enable: { _ in
            },
            disable: { _ in
                seat.closeKeyboardDevices()
                seat.libSeat?.disableSeat()
            }
        ))
        seat.libSeat = libSeat
        print("TinySwiftWL: libseat opened (name='\(libSeat.seatName())')")

        seat.openKeyboardDevices()

        if libSeat.getFd() >= 0 {
            if wl_event_loop_add_fd(loop, libSeat.getFd(), WlEventMask.readable, libseatDispatchTrampoline, dataPtr) == nil {
                print("TinySwiftWL: warning: could not add libseat fd to event loop")
            }
        }

        wl_display_run(display)
        print("TinySwiftWL: exiting")
    }
}
