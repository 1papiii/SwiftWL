import Testing
import Synchronization
import Glibc
import Dispatch
@testable import wayland_swift
import wayland

private final class XdgBindEnv: @unchecked Sendable {
    let bound = Mutex(false)
}

private final class DisplayBox: @unchecked Sendable {
    let pointer: OpaquePointer
    init(_ pointer: OpaquePointer) { self.pointer = pointer }
}

@Suite("XDG Shell")
struct XdgShellTests {

    @Test("xdg_wm_base interface helpers are exposed")
    func xdgInterfacesExposed() {
        let wmBase = wl_swift_xdg_wm_base_interface()
        #expect(wmBase != nil)
        #expect(String(cString: wmBase!.pointee.name) == "xdg_wm_base")

        let surface = wl_swift_xdg_surface_interface()
        #expect(surface != nil)
        #expect(String(cString: surface!.pointee.name) == "xdg_surface")

        let toplevel = wl_swift_xdg_toplevel_interface()
        #expect(toplevel != nil)
        #expect(String(cString: toplevel!.pointee.name) == "xdg_toplevel")

        let popup = wl_swift_xdg_popup_interface()
        #expect(popup != nil)
        #expect(String(cString: popup!.pointee.name) == "xdg_popup")
    }

    @Test("xdg_wm_base global can be created and destroyed")
    func xdgWmBaseGlobalLifecycle() throws {
        let display = try #require(WlDisplay())
        defer { display.destroy() }
        let bind: @convention(c) (OpaquePointer?, UnsafeMutableRawPointer?, UInt32, UInt32) -> Void = { _, _, _, _ in }
        guard let global = wl_global_create(
            display.pointer, wl_swift_xdg_wm_base_interface(), 7, nil, bind
        ) else {
            Issue.record("wl_global_create(xdg_wm_base) failed"); return
        }
        wl_global_destroy(global)
    }

    @Test("end-to-end: client discovers and binds xdg_wm_base global")
    func endToEndClientBindsXdgWmBase() throws {
        let display = try #require(WlDisplay())
        defer { display.destroy() }
        let env = XdgBindEnv()
        let uniqueName = "swiftwl-xdg-bind-\(getpid())"
        try display.addSocket(name: uniqueName)

        // Register compositor global (needed for client to connect and query registry)
        let compBind: @convention(c) (OpaquePointer?, UnsafeMutableRawPointer?, UInt32, UInt32) -> Void = { _, _, _, _ in }
        _ = wl_global_create(display.pointer, wl_swift_compositor_interface(), 1, nil, compBind)

        // Register xdg_wm_base global
        let xdgBind: @convention(c) (OpaquePointer?, UnsafeMutableRawPointer?, UInt32, UInt32) -> Void = { client, data, version, id in
            guard let client = client else { return }
            if let r = wl_resource_create(client, wl_swift_xdg_wm_base_interface(), Int32(version), id) {
                let e = Unmanaged<XdgBindEnv>.fromOpaque(data!).takeUnretainedValue()
                e.bound.withLock { $0 = true }
                _ = r
            }
        }
        _ = wl_global_create(
            display.pointer, wl_swift_xdg_wm_base_interface(), 7,
            Unmanaged.passUnretained(env).toOpaque(), xdgBind
        )

        // Run display in background
        let displayBox = DisplayBox(display.pointer)
        DispatchQueue.global().async { wl_display_run(displayBox.pointer) }
        usleep(10000)
        defer { wl_display_terminate(displayBox.pointer); usleep(20000) }

        // Client connect
        guard let cd = uniqueName.withCString({ wl_display_connect($0) }) else {
            Issue.record("wl_display_connect returned nil"); return
        }
        defer { wl_display_disconnect(cd) }

        guard let reg = wl_display_get_registry(cd) else {
            Issue.record("wl_display_get_registry returned nil"); return
        }
        defer { wl_registry_destroy(reg) }

        // Discover xdg_wm_base global
        var wmBaseName = UInt32.max
        let rd = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        rd.pointee = UInt32.max
        let rl = wl_registry_listener(
            global: { data, _, name, iface, _ in
                let p = UnsafeMutablePointer<UInt32>(OpaquePointer(data!))!
                if String(cString: iface!) == "xdg_wm_base" { p.pointee = name }
            },
            global_remove: { _, _, _ in }
        )
        withUnsafePointer(to: rl) { _ = wl_registry_add_listener(reg, $0, UnsafeMutableRawPointer(rd)) }
        _ = wl_display_roundtrip(cd)
        wmBaseName = rd.pointee; rd.deallocate()
        #expect(wmBaseName != UInt32.max, "Did not discover xdg_wm_base global")

        // Bind to it - the server's bind handler should fire
        let proxy = wl_registry_bind(reg, wmBaseName, wl_swift_xdg_wm_base_interface(), 7)
        _ = wl_display_roundtrip(cd)
        #expect(proxy != nil, "Failed to bind xdg_wm_base")
        #expect(env.bound.withLock { $0 }, "Server bind handler did not execute")
        _ = proxy
    }
}
