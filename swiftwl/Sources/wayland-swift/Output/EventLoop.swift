import wayland
import Glibc

public enum WlEventMask {
    public static let readable: UInt32 = 0x01
    public static let writable: UInt32 = 0x02
    public static let hangup: UInt32 = 0x04
    public static let error: UInt32 = 0x08
}

public final class WlEventLoop: @unchecked Sendable {
    public let pointer: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func getFd() -> Int32 {
        wl_event_loop_get_fd(pointer)
    }

    @discardableResult
    public func addFd(
        fd: Int32,
        mask: UInt32,
        handler: @escaping @Sendable (Int32, UInt32) -> Void
    ) throws -> WlEventSource {
        let box = CBridge<WlEventSource.Kind>(.fd(handler: handler))
        guard let ptr = wl_event_loop_add_fd(pointer, fd, mask, fdTrampoline, box.opaque) else {
            throw WlError(kind: .allocation, message: "wl_event_loop_add_fd returned nil")
        }
        return WlEventSource(pointer: ptr, box: box)
    }

    @discardableResult
    public func addTimer(
        delayMs: Int32,
        handler: @escaping @Sendable () -> Void
    ) throws -> WlEventSource {
        let box = CBridge<WlEventSource.Kind>(.timer(handler: handler))
        guard let ptr = wl_event_loop_add_timer(pointer, timerTrampoline, box.opaque) else {
            throw WlError(kind: .allocation, message: "wl_event_loop_add_timer returned nil")
        }
        let source = WlEventSource(pointer: ptr, box: box)
        let err = wl_event_source_timer_update(ptr, delayMs)
        if err != 0 {
            wl_event_source_remove(ptr)
            throw WlError(kind: .cError, message: "wl_event_source_timer_update failed", errnoValue: errno)
        }
        return source
    }

    @discardableResult
    public func addSignal(
        signal: Int32,
        handler: @escaping @Sendable (Int32) -> Void
    ) throws -> WlEventSource {
        let box = CBridge<WlEventSource.Kind>(.signal(handler: handler))
        guard let ptr = wl_event_loop_add_signal(pointer, signal, signalTrampoline, box.opaque) else {
            throw WlError(kind: .allocation, message: "wl_event_loop_add_signal returned nil")
        }
        return WlEventSource(pointer: ptr, box: box)
    }

    @discardableResult
    public func addIdle(
        handler: @escaping @Sendable () -> Void
    ) throws -> WlEventSource {
        let box = CBridge<WlEventSource.Kind>(.idle(handler: handler))
        guard let ptr = wl_event_loop_add_idle(pointer, idleTrampoline, box.opaque) else {
            throw WlError(kind: .allocation, message: "wl_event_loop_add_idle returned nil")
        }
        return WlEventSource(pointer: ptr, box: box)
    }

    @discardableResult
    public func dispatch(timeout: Int32 = -1) throws -> Int32 {
        let dispatched = wl_event_loop_dispatch(pointer, timeout)
        if dispatched < 0 {
            throw WlError(kind: .cError, message: "wl_event_loop_dispatch failed", errnoValue: errno)
        }
        return dispatched
    }

    public func dispatchIdle() {
        wl_event_loop_dispatch_idle(pointer)
    }
}

public final class WlEventSource: @unchecked Sendable {

    public enum Kind: Sendable {
        case fd(handler: @Sendable (Int32, UInt32) -> Void)
        case timer(handler: @Sendable () -> Void)
        case signal(handler: @Sendable (Int32) -> Void)
        case idle(handler: @Sendable () -> Void)
    }

    public let pointer: OpaquePointer
    public let kind: Kind
    private let box: CBridge<Kind>
    private var removed = false

    init(pointer: OpaquePointer, box: CBridge<Kind>) {
        self.pointer = pointer
        self.box = box
        self.kind = box.payload
    }

    deinit {

        if !removed {
            wl_event_source_remove(pointer)
        }
    }

    @discardableResult
    public func remove() throws -> Bool {
        guard !removed else { return false }
        removed = true
        let err = wl_event_source_remove(pointer)
        if err != 0 {
            throw WlError(kind: .cError, message: "wl_event_source_remove failed", errnoValue: errno)
        }
        return true
    }

    public func check() {
        guard !removed else { return }
        wl_event_source_check(pointer)
    }

    public func fdUpdate(mask: UInt32) throws {
        guard !removed else {
            throw WlError(kind: .state, message: "cannot update a removed event source")
        }
        let err = wl_event_source_fd_update(pointer, mask)
        if err != 0 {
            throw WlError(kind: .cError, message: "wl_event_source_fd_update failed", errnoValue: errno)
        }
    }

    public func timerUpdate(delayMs: Int32) throws {
        guard !removed else {
            throw WlError(kind: .state, message: "cannot update a removed event source")
        }
        let err = wl_event_source_timer_update(pointer, delayMs)
        if err != 0 {
            throw WlError(kind: .cError, message: "wl_event_source_timer_update failed", errnoValue: errno)
        }
    }
}

private let fdTrampoline: @convention(c) (Int32, UInt32, UnsafeMutableRawPointer?) -> Int32 = { fd, mask, data in
    guard let kind = CBridge<WlEventSource.Kind>.load(data)?.payload else { return 0 }
    switch kind {
    case .fd(let handler):
        handler(fd, mask)
    default:
        break
    }
    return 0
}

private let timerTrampoline: @convention(c) (UnsafeMutableRawPointer?) -> Int32 = { data in
    guard let kind = CBridge<WlEventSource.Kind>.load(data)?.payload else { return 0 }
    if case .timer(let handler) = kind { handler() }
    return 0
}

private let signalTrampoline: @convention(c) (Int32, UnsafeMutableRawPointer?) -> Int32 = { signal, data in
    guard let kind = CBridge<WlEventSource.Kind>.load(data)?.payload else { return 0 }
    if case .signal(let handler) = kind { handler(signal) }
    return 0
}

private let idleTrampoline: @convention(c) (UnsafeMutableRawPointer?) -> Void = { data in
    guard let kind = CBridge<WlEventSource.Kind>.load(data)?.payload else { return }
    if case .idle(let handler) = kind { handler() }
}