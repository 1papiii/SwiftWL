import wayland

public final class WlResource: @unchecked Sendable {
    public let pointer: UnsafeMutablePointer<wl_resource>

    public init(_ pointer: UnsafeMutablePointer<wl_resource>) {
        self.pointer = pointer
    }

    public convenience init?(
        client: OpaquePointer?,
        interface: UnsafePointer<wl_interface>,
        version: Int32,
        id: UInt32
    ) {
        guard let ptr = wl_resource_create(client, interface, version, id) else { return nil }
        self.init(ptr)
    }

    public func destroy() {
        wl_resource_destroy(pointer)
    }

    public func setUserData<T: AnyObject>(_ obj: T) {
        wl_resource_set_user_data(pointer, Unmanaged.passUnretained(obj).toOpaque())
    }

    public func getUserData<T: AnyObject>(as type: T.Type) -> T? {
        guard let raw = wl_resource_get_user_data(pointer) else { return nil }
        return Unmanaged<T>.fromOpaque(raw).takeUnretainedValue()
    }

    public func setCompositorImplementation(
        context: AnyObject,
        createSurface: @escaping @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void,
        createRegion: @escaping @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?, UInt32) -> Void,
        release: @escaping @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?) -> Void
    ) {
        let envPtr = UnsafeMutablePointer<wl_swift_compositor_env>.allocate(capacity: 1)
        envPtr.pointee = wl_swift_compositor_env(
            swift_context: Unmanaged.passUnretained(context).toOpaque(),
            create_surface: createSurface,
            create_region: createRegion,
            release: release
        )
        wl_swift_set_compositor_implementation(pointer, envPtr)
    }

    public func postError(code: UInt32, message: String) {
        message.withCString { wl_swift_resource_post_error(pointer, code, $0) }
    }

    public func postNoMemory() {
        wl_resource_post_no_memory(pointer)
    }
}
