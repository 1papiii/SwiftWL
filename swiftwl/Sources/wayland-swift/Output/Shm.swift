import wayland
import Glibc
import Foundation

public class WlShm {
    public let pointer: OpaquePointer
    public let resource: UnsafeMutablePointer<wl_resource>

    public init(_ pointer: OpaquePointer, resource: UnsafeMutablePointer<wl_resource>) {
        self.pointer = pointer
        self.resource = resource
    }

    public func release() {
        wl_shm_release(pointer)
    }

    public func createPool(fd: Int32, size: Int32) -> WlShmPool {
        let poolPointer = wl_shm_create_pool(pointer, fd, size)!
        return WlShmPool(poolPointer)
    }

    public static func format(buffer: OpaquePointer) -> UInt32 {
        return wl_shm_buffer_get_format(buffer)
    }
}

public class WlShmPool {
    public let pointer: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func destroy() {
        wl_shm_pool_destroy(pointer)
    }

    public func resize(size: Int32) {
        wl_shm_pool_resize(pointer, size)
    }

    public func createBuffer(offset: Int32 = 0, width: Int32, height: Int32, stride: Int32, format: UInt32) -> WlBuffer {
        let bufferPointer = wl_shm_pool_create_buffer(pointer, offset, width, height, stride, format)!
        return WlBuffer(bufferPointer)
    }
}

public class WlBuffer {
    public let pointer: OpaquePointer
    public let resource: UnsafeMutablePointer<wl_resource>?

    public init(_ pointer: OpaquePointer, resource: UnsafeMutablePointer<wl_resource>? = nil) {
        self.pointer = pointer
        self.resource = resource
    }

    public func destroy() {
        wl_buffer_destroy(pointer)
    }

    public func sendRelease() {
        guard let resource = resource else {
            fatalError("WlBuffer.sendRelease() requires a server-side wl_resource")
        }
        wl_buffer_send_release(resource)
    }
}