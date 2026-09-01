import wayland

public class WlRegion {
    public let pointer: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func destroy() {
        wl_region_destroy(pointer)
    }

    public func add(x: Int32, y: Int32, width: Int32, height: Int32) {
        wl_region_add(pointer, x, y, width, height)
    }

    public func subtract(x: Int32, y: Int32, width: Int32, height: Int32) {
        wl_region_subtract(pointer, x, y, width, height)
    }
}