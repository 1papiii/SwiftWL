import wayland
import Glibc

public struct LibSeatDevice {
    public let deviceId: Int32
    public let fd: Int32
    public let path: String

    public init(deviceId: Int32, fd: Int32, path: String) {
        self.deviceId = deviceId
        self.fd = fd
        self.path = path
    }
}

public struct LibSeatListenerHandlers: @unchecked Sendable {
    public let enable: (OpaquePointer) -> Void
    public let disable: (OpaquePointer) -> Void

    public init(enable: @escaping (OpaquePointer) -> Void,
                disable: @escaping (OpaquePointer) -> Void) {
        self.enable = enable
        self.disable = disable
    }
}

public final class LibSeat: @unchecked Sendable {
    public var pointer: OpaquePointer
    private let listener: LibSeatListenerHandlers?
    private var bridge: CBridge<LibSeatListenerHandlers>?
    private let isNullSeat: Bool
    private let sentinel: UnsafeMutableRawPointer?

    public static func make(listener: LibSeatListenerHandlers? = nil) -> LibSeat {
        if let seat = tryRealOpen(listener: listener) { return seat }
        setenv("LIBSEAT_BACKEND", "builtin", 1)
        defer { unsetenv("LIBSEAT_BACKEND") }
        if let seat = tryRealOpen(listener: listener) { return seat }
        print("LibSeat: using null seat (direct device access)")
        return LibSeat(nullSeatWith: listener)
    }

    private static func tryRealOpen(listener: LibSeatListenerHandlers?) -> LibSeat? {
        if let listener = listener {
            let box = CBridge(listener)
            var cListener = libseat_seat_listener(
                enable_seat: seatEnableTrampoline,
                disable_seat: seatDisableTrampoline
            )
            var ptr: OpaquePointer? = nil
            withUnsafeMutablePointer(to: &cListener) { lp in
                ptr = libseat_open_seat(lp, box.opaque)
            }
            guard let ptr = ptr else { return nil }
            return LibSeat(realPointer: ptr, listener: listener, bridge: box)
        }
        guard let ptr = libseat_open_seat(nil, nil) else { return nil }
        return LibSeat(realPointer: ptr, listener: nil, bridge: nil)
    }

    private init(realPointer: OpaquePointer, listener: LibSeatListenerHandlers?, bridge: CBridge<LibSeatListenerHandlers>?) {
        self.pointer = realPointer
        self.listener = listener
        self.bridge = bridge
        self.isNullSeat = false
        self.sentinel = nil
    }

    private init(nullSeatWith listener: LibSeatListenerHandlers?) {
        let s = UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 1)
        self.sentinel = s
        self.pointer = OpaquePointer(s)
        self.listener = listener
        self.bridge = nil
        self.isNullSeat = true
        if let listener = listener { listener.enable(pointer) }
    }

    deinit {
        if isNullSeat {
            sentinel?.deallocate()
        } else {
            libseat_close_seat(pointer)
        }
    }

    public func getFd() -> Int32 {
        isNullSeat ? -1 : libseat_get_fd(pointer)
    }

    public func dispatch(timeout: Int32 = 0) -> Int32 {
        isNullSeat ? 0 : libseat_dispatch(pointer, timeout)
    }

    public func openDevice(path: String) -> LibSeatDevice? {
        if isNullSeat {
            let fd = Glibc.open(path, O_RDWR | O_NONBLOCK)
            guard fd >= 0 else { return nil }
            return LibSeatDevice(deviceId: -1, fd: fd, path: path)
        }
        var fd: Int32 = -1
        let deviceId = path.withCString { cPath in
            libseat_open_device(pointer, cPath, &fd)
        }
        guard deviceId >= 0, fd >= 0 else { return nil }
        return LibSeatDevice(deviceId: deviceId, fd: fd, path: path)
    }

    public func closeDevice(_ device: LibSeatDevice) {
        close(device.fd)
        if !isNullSeat { _ = libseat_close_device(pointer, device.deviceId) }
    }

    public func seatName() -> String {
        isNullSeat ? "seat0" : String(cString: libseat_seat_name(pointer))
    }

    public func switchSession(_ session: Int32) {
        if !isNullSeat { _ = libseat_switch_session(pointer, Int32(session)) }
    }

    public func disableSeat() {
        if !isNullSeat { _ = libseat_disable_seat(pointer) }
    }

    public static func setLogLevel(_ level: libseat_log_level) {
        libseat_set_log_level(level)
    }
}

private let seatEnableTrampoline: @convention(c) (OpaquePointer?, UnsafeMutableRawPointer?) -> Void = { seat, userdata in
    guard let seat = seat, let userdata = userdata else { return }
    guard let handlers = CBridge<LibSeatListenerHandlers>.load(userdata)?.payload else { return }
    handlers.enable(seat)
}

private let seatDisableTrampoline: @convention(c) (OpaquePointer?, UnsafeMutableRawPointer?) -> Void = { seat, userdata in
    guard let seat = seat, let userdata = userdata else { return }
    guard let handlers = CBridge<LibSeatListenerHandlers>.load(userdata)?.payload else { return }
    handlers.disable(seat)
}