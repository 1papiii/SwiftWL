import wayland

public class WlSurface {
    public let pointer: OpaquePointer
    public let resource: UnsafeMutablePointer<wl_resource>?

    public init(_ pointer: OpaquePointer, resource: UnsafeMutablePointer<wl_resource>? = nil) {
        self.pointer = pointer
        self.resource = resource
    }

    public func attach(buffer: OpaquePointer, x: Int32, y: Int32) {
        wl_surface_attach(pointer, buffer, x, y)
    }

    public func destroy() {
        wl_surface_destroy(pointer)
    }

    public func damage(x: Int32, y: Int32, width: Int32, height: Int32) {
        wl_surface_damage(pointer, x, y, width, height)
    }

    public func frame() -> WlCallback {
        WlCallback(wl_surface_frame(pointer)!)
    }

    public func setOpaqueRegion(region: OpaquePointer) {
        wl_surface_set_opaque_region(pointer, region)
    }

    public func setInputRegion(region: OpaquePointer) {
        wl_surface_set_input_region(pointer, region)
    }

    public func commit() {
        wl_surface_commit(pointer)
    }

    public func setBufferTransform(transform: Int32) {
        wl_surface_set_buffer_transform(pointer, transform)
    }

    public func setBufferScale(scale: Int32) {
        wl_surface_set_buffer_scale(pointer, scale)
    }

    public func damageBuffer(x: Int32, y: Int32, width: Int32, height: Int32) {
        wl_surface_damage_buffer(pointer, x, y, width, height)
    }

    public func offset(x: Int32, y: Int32) {
        wl_surface_offset(pointer, x, y)
    }

    public func getRelease() -> WlCallback {
        WlCallback(wl_surface_get_release(pointer)!)
    }

    public func setListener(
        enter: @escaping @Sendable (WlOutput) -> Void,
        leave: @escaping @Sendable (WlOutput) -> Void,
        preferredBufferScale: @escaping @Sendable (Int32) -> Void,
        preferredBufferTransform: @escaping @Sendable (UInt32) -> Void
    ) {
        let box = CBridge(WlSurfaceListenerHandlers(
            enter: enter, leave: leave,
            preferredBufferScale: preferredBufferScale,
            preferredBufferTransform: preferredBufferTransform
        ))
        let listener = wl_surface_listener(
            enter: surfaceEnterTrampoline,
            leave: surfaceLeaveTrampoline,
            preferred_buffer_scale: surfacePrefScaleTrampoline,
            preferred_buffer_transform: surfacePrefTransformTrampoline
        )
        withUnsafePointer(to: listener) { listenerPtr in
            _ = wl_surface_add_listener(pointer, listenerPtr, box.opaque)
        }
    }

    public func enter(output: UnsafeMutablePointer<wl_resource>) {
        guard let resource = resource else {
            fatalError("WlSurface.enter(output:) requires a server-side wl_resource")
        }
        wl_surface_send_enter(resource, output)
    }

    public func leave(output: UnsafeMutablePointer<wl_resource>) {
        guard let resource = resource else {
            fatalError("WlSurface.leave(output:) requires a server-side wl_resource")
        }
        wl_surface_send_leave(resource, output)
    }

    public func preferredBufferScale(factor: Int32) {
        guard let resource = resource else {
            fatalError("WlSurface.preferredBufferScale(factor:) requires a server-side wl_resource")
        }
        wl_surface_send_preferred_buffer_scale(resource, factor)
    }

    public func preferredBufferTransform(transform: UInt32) {
        guard let resource = resource else {
            fatalError("WlSurface.preferredBufferTransform(transform:) requires a server-side wl_resource")
        }
        wl_surface_send_preferred_buffer_transform(resource, transform)
    }
}

private struct WlSurfaceListenerHandlers: @unchecked Sendable {
    let enter: @Sendable (WlOutput) -> Void
    let leave: @Sendable (WlOutput) -> Void
    let preferredBufferScale: @Sendable (Int32) -> Void
    let preferredBufferTransform: @Sendable (UInt32) -> Void
}

private let surfaceEnterTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, OpaquePointer?) -> Void = { data, _, output in
    guard let handlers = CBridge<WlSurfaceListenerHandlers>.load(data)?.payload else { return }
    guard let output = output else { return }
    handlers.enter(WlOutput(output, resource: nil))
}

private let surfaceLeaveTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, OpaquePointer?) -> Void = { data, _, output in
    guard let handlers = CBridge<WlSurfaceListenerHandlers>.load(data)?.payload else { return }
    guard let output = output else { return }
    handlers.leave(WlOutput(output, resource: nil))
}

private let surfacePrefScaleTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, Int32) -> Void = { data, _, factor in
    guard let handlers = CBridge<WlSurfaceListenerHandlers>.load(data)?.payload else { return }
    handlers.preferredBufferScale(factor)
}

private let surfacePrefTransformTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UInt32) -> Void = { data, _, transform in
    guard let handlers = CBridge<WlSurfaceListenerHandlers>.load(data)?.payload else { return }
    handlers.preferredBufferTransform(transform)
}
