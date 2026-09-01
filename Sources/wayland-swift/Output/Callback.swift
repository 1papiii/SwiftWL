import wayland

public class WlCallback {
    public let pointer: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func destroy() {
        wl_callback_destroy(pointer)
    }

    public func setDoneHandler(_ handler: @escaping @Sendable (UInt32) -> Void) {
        let box = CBridge(handler)
        let listener = wl_callback_listener(done: callbackDoneTrampoline)
        withUnsafePointer(to: listener) { listenerPtr in
            _ = wl_callback_add_listener(pointer, listenerPtr, box.opaque)
        }
    }
}

private let callbackDoneTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UInt32) -> Void = { data, _, callbackData in
    guard let handler = CBridge<@Sendable (UInt32) -> Void>.load(data)?.payload else { return }
    handler(callbackData)
}