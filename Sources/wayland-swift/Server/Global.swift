import wayland

public final class WlGlobal: @unchecked Sendable {

    public typealias BindHandler = @Sendable (OpaquePointer?, UInt32, UInt32) -> Void

    public let pointer: OpaquePointer
    public let interface: UnsafePointer<wl_interface>
    public let version: Int32

    private let box: CBridge<BindHandler>

    public init(
        display: WlDisplay,
        interface: UnsafePointer<wl_interface>,
        version: Int32,
        bind: @escaping BindHandler
    ) throws {
        let box = CBridge(bind)
        guard let ptr = wl_global_create(display.pointer, interface, version, box.opaque, globalBindTrampoline) else {
            throw WlError(kind: .allocation, message: "wl_global_create returned nil")
        }
        self.pointer = ptr
        self.interface = interface
        self.version = version
        self.box = box
    }

    public func remove() {
        wl_global_remove(pointer)
    }


    public func destroy() {
        wl_global_destroy(pointer)
    }
}

private let globalBindTrampoline: @convention(c) (OpaquePointer?, UnsafeMutableRawPointer?, UInt32, UInt32) -> Void = { client, data, version, id in
    guard let box = CBridge<WlGlobal.BindHandler>.load(data) else { return }
    box.payload(client, version, id)
}