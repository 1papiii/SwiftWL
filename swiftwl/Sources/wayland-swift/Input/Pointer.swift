import wayland

public class WlPointer {
    public let pointer: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func destroy() {
        wl_pointer_destroy(pointer)
    }

    public func release() {
        wl_pointer_release(pointer)
    }
}