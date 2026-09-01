import wayland

public class WlTouch {
    public let pointer: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func destroy() {
        wl_touch_destroy(pointer)
    }

    public func release() {
        wl_touch_release(pointer)
    }
}