import wayland

public final class XdgWmBase: @unchecked Sendable {

    public let resource: UnsafeMutablePointer<wl_resource>

    public init(_ resource: UnsafeMutablePointer<wl_resource>) {
        self.resource = resource
    }

    public func setImplementation(
        context: AnyObject,
        state: UnsafeMutableRawPointer? = nil,
        destroy: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?
        ) -> Void)? = nil,
        createPositioner: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32
        ) -> Void)? = nil,
        getXdgSurface: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?,
            UInt32, UnsafeMutablePointer<wl_resource>?
        ) -> Void)? = nil,
        pong: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32
        ) -> Void)? = nil
    ) {
        let envPtr = UnsafeMutablePointer<wl_swift_xdg_wm_base_env>.allocate(capacity: 1)
        envPtr.pointee = wl_swift_xdg_wm_base_env(
            swift_context: Unmanaged.passUnretained(context).toOpaque(),
            state: state,
            destroy: destroy.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            create_positioner: createPositioner.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            get_xdg_surface: getXdgSurface.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            pong: pong.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) }
        )
        wl_swift_set_xdg_wm_base_implementation(resource, envPtr)
    }

    public static func createGlobal(
        display: OpaquePointer,
        version: Int32 = 7,
        bind: @escaping @convention(c) (
            OpaquePointer?, UnsafeMutableRawPointer?, UInt32, UInt32
        ) -> Void
    ) -> OpaquePointer? {
        wl_global_create(display, wl_swift_xdg_wm_base_interface(), version, nil, bind)
    }

    public func sendPing(serial: UInt32) {
        wl_swift_xdg_wm_base_send_ping(resource, serial)
    }
}