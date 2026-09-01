import wayland

public class WlCompositor {
    public let pointer: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func createSurface() -> WlSurface {
        WlSurface(wl_compositor_create_surface(pointer)!)
    }

    public func createRegion() -> WlRegion {
        WlRegion(wl_compositor_create_region(pointer)!)
    }

    public func release() {
        wl_compositor_release(pointer)
    }
}
