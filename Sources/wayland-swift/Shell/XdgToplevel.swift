import wayland

public final class XdgToplevel: @unchecked Sendable {

    public let resource: UnsafeMutablePointer<wl_resource>

    public init(_ resource: UnsafeMutablePointer<wl_resource>) {
        self.resource = resource
    }

    public func setImplementation(
        context: AnyObject,
        state: UnsafeMutableRawPointer? = nil,
        destroy: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?) -> Void)? = nil,
        setParent: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UnsafeMutablePointer<wl_resource>?) -> Void)? = nil,
        setTitle: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UnsafePointer<CChar>?) -> Void)? = nil,
        setAppId: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UnsafePointer<CChar>?) -> Void)? = nil,
        showWindowMenu: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UnsafeMutablePointer<wl_resource>?, UInt32, Int32, Int32) -> Void)? = nil,
        move: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void)? = nil,
        resize: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UnsafeMutablePointer<wl_resource>?, UInt32, UInt32) -> Void)? = nil,
        setMaxSize: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, Int32, Int32) -> Void)? = nil,
        setMinSize: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, Int32, Int32) -> Void)? = nil,
        setMaximized: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?) -> Void)? = nil,
        unsetMaximized: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?) -> Void)? = nil,
        setFullscreen: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UnsafeMutablePointer<wl_resource>?) -> Void)? = nil,
        unsetFullscreen: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?) -> Void)? = nil,
        setMinimized: (@convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?) -> Void)? = nil
    ) {
        let envPtr = UnsafeMutablePointer<wl_swift_xdg_toplevel_env>.allocate(capacity: 1)
        envPtr.pointee = wl_swift_xdg_toplevel_env(
            swift_context: Unmanaged.passUnretained(context).toOpaque(),
            state: state,
            destroy: destroy.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_parent: setParent.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_title: setTitle.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_app_id: setAppId.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            show_window_menu: showWindowMenu.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            move: move.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            resize: resize.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_max_size: setMaxSize.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_min_size: setMinSize.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_maximized: setMaximized.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            unset_maximized: unsetMaximized.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_fullscreen: setFullscreen.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            unset_fullscreen: unsetFullscreen.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_minimized: setMinimized.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) }
        )
        wl_swift_set_xdg_toplevel_implementation(resource, envPtr)
    }

    public func sendConfigure(width: Int32, height: Int32, states: inout wl_array) {
        wl_swift_xdg_toplevel_send_configure(resource, width, height, &states)
    }

    public func sendClose() {
        wl_swift_xdg_toplevel_send_close(resource)
    }

    public func sendConfigureBounds(width: Int32, height: Int32) {
        wl_swift_xdg_toplevel_send_configure_bounds(resource, width, height)
    }

    public func sendWmCapabilities(capabilities: inout wl_array) {
        wl_swift_xdg_toplevel_send_wm_capabilities(resource, &capabilities)
    }
}
