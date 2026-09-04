import wayland

public final class XdgSurface: @unchecked Sendable {

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
        getToplevel: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32
        ) -> Void)? = nil,
        getPopup: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?,
            UInt32, UnsafeMutablePointer<wl_resource>?,
            UnsafeMutablePointer<wl_resource>?
        ) -> Void)? = nil,
        setWindowGeometry: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?,
            Int32, Int32, Int32, Int32
        ) -> Void)? = nil,
        ackConfigure: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32
        ) -> Void)? = nil
    ) {
        let envPtr = UnsafeMutablePointer<wl_swift_xdg_surface_env>.allocate(capacity: 1)
        envPtr.pointee = wl_swift_xdg_surface_env(
            swift_context: Unmanaged.passUnretained(context).toOpaque(),
            state: state,
            destroy: destroy.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            get_toplevel: getToplevel.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            get_popup: getPopup.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_window_geometry: setWindowGeometry.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            ack_configure: ackConfigure.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) }
        )
        wl_swift_set_xdg_surface_implementation(resource, envPtr)
    }

    public func sendConfigure(serial: UInt32) {
        wl_swift_xdg_surface_send_configure(resource, serial)
    }
}