import Testing
import Synchronization
import Glibc
import Dispatch
@testable import wayland_swift
import wayland

private final class DisplayBox: @unchecked Sendable {
    let pointer: OpaquePointer
    init(_ pointer: OpaquePointer) { self.pointer = pointer }
}

private final class CompositorTestEnv: @unchecked Sendable {
    let surfaceCreated = Mutex(false)
    var surfaceResource: OpaquePointer? = nil

    let createSurface: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void = { envPtr, client, resource, id in
        let env = Unmanaged<CompositorTestEnv>.fromOpaque(envPtr!).takeUnretainedValue()
        guard let _ = WlResource(client: client, interface: wl_swift_surface_interface(), version: 1, id: id) else { return }
        env.surfaceCreated.withLock { $0 = true }
        env.surfaceResource = resource.map(OpaquePointer.init)
    }

    let createRegion: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void = { _, _, _, _ in }
    let release: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?) -> Void = { _, _, _ in }
}

@Suite("wayland Clang module")
struct WaylandTests {
    @Test("client + server APIs are exposed")
    func clientAndServerAreExposed() {
        let createDisplay = wl_display_create
        let createGlobal = wl_global_create
        _ = wl_signal.self
        _ = wl_registry_listener.self
        let connect = wl_display_connect
        _ = connect
        _ = wl_shm_format.self
        _ = (createDisplay, createGlobal)
    }

    @Test("server display lifecycle")
    func serverDisplayLifecycle() throws {
        guard let display = wl_display_create() else {
            Issue.record("wl_display_create() returned nil")
            return
        }
        let socket = wl_display_add_socket_auto(display)
        #expect(socket != nil)
        guard let global = wl_global_create(display, wl_swift_compositor_interface(), 1, nil, compositorBind) else {
            Issue.record("wl_global_create() returned nil")
            wl_display_destroy(display)
            return
        }
        wl_global_destroy(global)
        wl_display_destroy(display)
    }

    @Test("event loop: idle source runs via dispatchIdle")
    func eventLoopIdle() throws {
        let display = try #require(WlDisplay())
        defer { display.destroy() }
        let loop = display.getEventLoop()
        let ran = Mutex(false)
        let source = try loop.addIdle { ran.withLock { $0 = true } }
        defer { _ = try? source.remove() }
        loop.dispatchIdle()
        #expect(ran.withLock { $0 })
    }

    @Test("event loop: timer source fires on dispatch")
    func eventLoopTimer() throws {
        let display = try #require(WlDisplay())
        defer { display.destroy() }
        let loop = display.getEventLoop()
        let fired = Mutex(false)
        let source = try loop.addTimer(delayMs: 10) { fired.withLock { $0 = true } }
        defer { _ = try? source.remove() }
        _ = try loop.dispatch(timeout: 1000)
        #expect(fired.withLock { $0 })
    }

    @Test("event loop: fd source fires on socket readiness")
    func eventLoopFd() throws {
        let display = try #require(WlDisplay())
        defer { display.destroy() }
        let pair = UnsafeMutablePointer<Int32>.allocate(capacity: 2)
        defer { pair.deallocate() }
        let rc = socketpair(AF_UNIX, Int32(SOCK_STREAM.rawValue), 0, pair)
        #expect(rc == 0)
        let readEnd = pair[0]
        let writeEnd = pair[1]
        defer { close(readEnd); close(writeEnd) }
        let loop = display.getEventLoop()
        let ready = Mutex(false)
        let source = try loop.addFd(fd: readEnd, mask: WlEventMask.readable) { _, _ in
            ready.withLock { $0 = true }
        }
        defer { _ = try? source.remove() }
        var byte: UInt8 = 0xAA
        _ = write(writeEnd, &byte, 1)
        _ = try loop.dispatch(timeout: 1000)
        #expect(ready.withLock { $0 })
    }

    @Test("WlGlobal wrapper creates and destroys a global")
    func globalWrapperLifecycle() throws {
        let display = try #require(WlDisplay())
        defer { display.destroy() }
        _ = display.autoSocket()
        let global = try WlGlobal(
            display: display,
            interface: wl_swift_compositor_interface(),
            version: 1
        ) { _, version, id in
            _ = wl_resource_create(nil, wl_swift_compositor_interface(), Int32(version), id)
        }
        global.remove()
        global.destroy()
    }

    @Test("flushClients + terminate are no-op safe")
    func serverRuntimeSmoke() throws {
        let display = try #require(WlDisplay())
        display.flushClients()
        display.terminate()
        display.destroy()
    }

    @Test("end-to-end: client creates surface via compositor global")
    func endToEndSurfaceCreation() throws {
        let display = try #require(WlDisplay())
        let env = CompositorTestEnv()
        let uniqueName = "swiftwl-e2e-\(getpid())"
        try display.addSocket(name: uniqueName)

        let global = try WlGlobal(
            display: display,
            interface: wl_swift_compositor_interface(),
            version: 1
        ) { [env] client, version, id in
            guard let resource = WlResource(client: client, interface: wl_swift_compositor_interface(), version: Int32(version), id: id) else { return }
            resource.setCompositorImplementation(
                context: env,
                createSurface: env.createSurface,
                createRegion: env.createRegion,
                release: env.release
            )
        }
        defer { global.destroy() }

        let displayBox = DisplayBox(display.pointer)
        DispatchQueue.global().async {
            wl_display_run(displayBox.pointer)
        }
        usleep(10000)
        defer {
            wl_display_terminate(display.pointer)
            usleep(20000)
        }

        guard let clientDisplay = uniqueName.withCString({ wl_display_connect($0) }) else {
            Issue.record("wl_display_connect returned nil")
            return
        }
        defer { wl_display_disconnect(clientDisplay) }

        guard let registry = wl_display_get_registry(clientDisplay) else {
            Issue.record("wl_display_get_registry returned nil")
            return
        }
        defer { wl_registry_destroy(registry) }

        let compositorName = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        compositorName.pointee = UInt32.max
        let registryListener = wl_registry_listener(
            global: { data, reg, name, iface, ver in
                let ptr = UnsafeMutablePointer<UInt32>(OpaquePointer(data!))!
                if String(cString: iface!) == "wl_compositor" { ptr.pointee = name }
            },
            global_remove: { _, _, _ in }
        )
        withUnsafePointer(to: registryListener) { listener in
            let _ = wl_registry_add_listener(registry, listener, UnsafeMutableRawPointer(compositorName))
        }

        _ = wl_display_roundtrip(clientDisplay)
        #expect(compositorName.pointee != UInt32.max, "Did not receive compositor global announcement")

        let compositorProxy = OpaquePointer(wl_registry_bind(registry, compositorName.pointee, wl_swift_compositor_interface(), 1))!
        compositorName.deallocate()
        _ = wl_display_roundtrip(clientDisplay)
        _ = wl_compositor_create_surface(compositorProxy)
        _ = wl_display_roundtrip(clientDisplay)

        #expect(env.surfaceCreated.withLock { $0 })
    }
}

private func compositorBind(
    _ client: OpaquePointer?, _ data: UnsafeMutableRawPointer?,
    _ version: UInt32, _ id: UInt32
) {
    _ = wl_resource_create(client, wl_swift_compositor_interface(), Int32(version), id)
}
