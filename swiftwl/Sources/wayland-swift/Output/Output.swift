import wayland

public enum WlOutputSubpixel : Int32 {
    case unknown = 0
    case none = 1
    case horizontal_rgb = 2
    case horizontal_bgr = 3
    case vertical_rgb = 4
    case vertical_bgr = 5
}

public enum WlOutputTransform : Int32 {
    case normal = 0
    case _90 = 1
    case _180 = 2
    case _270 = 3
    case flipped = 4
    case flipped_90 = 5
    case flipped_180 = 6
    case flipped_270 = 7
}

public enum WlOutputMode : UInt32 {
    case current = 0x1
    case preferred = 0x2
}

public class WlOutput {
    public let pointer: OpaquePointer

    public let resource: UnsafeMutablePointer<wl_resource>?

    public init(_ pointer: OpaquePointer, resource: UnsafeMutablePointer<wl_resource>? = nil) {
        self.pointer = pointer
        self.resource = resource
    }

    public func release() {
        wl_output_release(pointer)
    }

    public func destroy() {
        wl_output_destroy(pointer)
    }

    public func geometry(x: Int32, y: Int32, physical_width: Int32, physical_height: Int32, subpixel: Int32, make: UnsafePointer<CChar>!, model: UnsafePointer<CChar>!, transform: Int32) {
        guard let resource = resource else {
            fatalError("WlOutput.geometry(...) requires a server-side wl_resource")
        }
        wl_output_send_geometry(resource, x, y, physical_width, physical_height, subpixel, make, model, transform)
    }

    public func mode(flags: WlOutputMode.RawValue, width: Int32, height: Int32, refresh: Int32) {
        guard let resource = resource else {
            fatalError("WlOutput.mode(...) requires a server-side wl_resource")
        }
        wl_output_send_mode(resource, flags, width, height, refresh)
    }

    public func scale(factor: Int32) {
        guard let resource = resource else {
            fatalError("WlOutput.scale(...) requires a server-side wl_resource")
        }
        wl_output_send_scale(resource, factor)
    }

    public func name(name: UnsafePointer<CChar>!) {
        guard let resource = resource else {
            fatalError("WlOutput.name(...) requires a server-side wl_resource")
        }
        wl_output_send_name(resource, name)
    }

    public func description(desc: UnsafePointer<CChar>!) {
        guard let resource = resource else {
            fatalError("WlOutput.description(...) requires a server-side wl_resource")
        }
        wl_output_send_description(resource, desc)
    }
}