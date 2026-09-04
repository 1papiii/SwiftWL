import wayland

public final class XdgPopup: @unchecked Sendable {

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
        grab: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?,
            UnsafeMutablePointer<wl_resource>?, UInt32
        ) -> Void)? = nil,
        reposition: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?,
            UnsafeMutablePointer<wl_resource>?, UInt32
        ) -> Void)? = nil
    ) {
        let envPtr = UnsafeMutablePointer<wl_swift_xdg_popup_env>.allocate(capacity: 1)
        envPtr.pointee = wl_swift_xdg_popup_env(
            swift_context: Unmanaged.passUnretained(context).toOpaque(),
            state: state,
            destroy: destroy.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            grab: grab.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            reposition: reposition.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) }
        )
        wl_swift_set_xdg_popup_implementation(resource, envPtr)
    }

    public func sendConfigure(x: Int32, y: Int32, width: Int32, height: Int32) {
        wl_swift_xdg_popup_send_configure(resource, x, y, width, height)
    }

    public func sendPopupDone() {
        wl_swift_xdg_popup_send_popup_done(resource)
    }

    public func sendRepositioned(token: UInt32) {
        wl_swift_xdg_popup_send_repositioned(resource, token)
    }
}