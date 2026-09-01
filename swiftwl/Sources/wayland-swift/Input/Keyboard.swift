import wayland

public class WlKeyboard {
    public let pointer: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func destroy() {
        wl_keyboard_destroy(pointer)
    }

    public func release() {
        wl_keyboard_release(pointer)
    }
}