import wayland
import Glibc

public class WlDisplay {
    public let pointer: OpaquePointer

    public init?() {
        guard let wlDisplay = wl_display_create() else {
            return nil
        }

        self.pointer = wlDisplay
    }

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public static func connect(name: String? = nil) -> WlDisplay? {
        let ptr = name?.withCString { wl_display_connect($0) } ?? wl_display_connect(nil)
        return ptr.map { WlDisplay($0) }
    }

    public func start() {
        wl_display_run(pointer)
    }

    public func terminate() {
        wl_display_terminate(pointer)
    }

    public func getEventLoop() -> WlEventLoop {
        WlEventLoop(wl_display_get_event_loop(pointer)!)
    }

    public func flushClients() {
        wl_display_flush_clients(pointer)
    }

    public func destroy() {
        wl_display_destroy(pointer)
    }

    public func addSocket(name: String) throws {
        let result = name.withCString { wl_display_add_socket(pointer, $0) }
        if result != 0 {
            throw WlError(message: "wl_display_add_socket failed for '\(name)'", errnoValue: errno)
        }
    }

    public func autoSocket() -> String? {
        guard let socket = wl_display_add_socket_auto(pointer) else {
            return nil
        }

        return String(cString: socket)
    }

    public func getFd() -> Int32 {
        wl_display_get_fd(pointer)
    }

    @discardableResult
    public func dispatch() throws -> Int32 {
        let result = wl_display_dispatch(pointer)
        if result < 0 {
            throw WlError(message: "wl_display_dispatch failed", errnoValue: errno)
        }
        return result
    }

    @discardableResult
    public func dispatchPending() throws -> Int32 {
        let result = wl_display_dispatch_pending(pointer)
        if result < 0 {
            throw WlError(message: "wl_display_dispatch_pending failed", errnoValue: errno)
        }
        return result
    }

    @discardableResult
    public func roundtrip() throws -> Int32 {
        let result = wl_display_roundtrip(pointer)
        if result < 0 {
            throw WlError(message: "wl_display_roundtrip failed", errnoValue: errno)
        }
        return result
    }
}