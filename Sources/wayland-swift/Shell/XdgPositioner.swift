import wayland

public final class XdgPositioner: @unchecked Sendable {

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
        setSize: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?,
            Int32, Int32
        ) -> Void)? = nil,
        setAnchorRect: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?,
            Int32, Int32, Int32, Int32
        ) -> Void)? = nil,
        setAnchor: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?,
            UInt32
        ) -> Void)? = nil,
        setGravity: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?,
            UInt32
        ) -> Void)? = nil,
        setConstraintAdjustment: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?,
            UInt32
        ) -> Void)? = nil,
        setOffset: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?,
            Int32, Int32
        ) -> Void)? = nil,
        setReactive: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?
        ) -> Void)? = nil,
        setParentSize: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?,
            Int32, Int32
        ) -> Void)? = nil,
        setParentConfigure: (@convention(c) (
            UnsafeMutableRawPointer?, UnsafeMutableRawPointer?,
            OpaquePointer?, UnsafeMutablePointer<wl_resource>?,
            UInt32
        ) -> Void)? = nil
    ) {
        let envPtr = UnsafeMutablePointer<wl_swift_xdg_positioner_env>.allocate(capacity: 1)
        envPtr.pointee = wl_swift_xdg_positioner_env(
            swift_context: Unmanaged.passUnretained(context).toOpaque(),
            state: state,
            destroy: destroy.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_size: setSize.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_anchor_rect: setAnchorRect.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_anchor: setAnchor.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_gravity: setGravity.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_constraint_adjustment: setConstraintAdjustment.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_offset: setOffset.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_reactive: setReactive.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_parent_size: setParentSize.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) },
            set_parent_configure: setParentConfigure.map { unsafeBitCast($0, to: UnsafeMutableRawPointer.self) }
        )
        wl_swift_set_xdg_positioner_implementation(resource, envPtr)
    }
}