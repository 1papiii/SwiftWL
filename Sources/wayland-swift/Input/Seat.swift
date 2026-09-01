import wayland
import Foundation

public enum WlSeatCapabilities : UInt32 {
    case pointer = 1
    case keyboard = 2
    case touch = 4
}

public enum WlSeatCapabilityError : UInt32 {
    case missing_capability = 0
}

public class WlSeat {
    public let pointer: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func getWlPointer() -> WlPointer {
        WlPointer(wl_seat_get_pointer(pointer)!)
    }

    public func getWlKeyboard() -> WlKeyboard {
        WlKeyboard(wl_seat_get_keyboard(pointer)!)
    }

    public func getWlTouch() -> WlTouch {
        WlTouch(wl_seat_get_touch(pointer)!)
    }

    public func release() {
        wl_seat_release(pointer)
    }

    public func setListener(
        capabilities: @escaping @Sendable (UInt32) -> Void,
        name: @escaping @Sendable (String) -> Void
    ) {
        let box = CBridge(WlSeatListenerHandlers(capabilities: capabilities, name: name))
        let listener = wl_seat_listener(
            capabilities: seatCapabilitiesTrampoline,
            name: seatNameTrampoline
        )
        withUnsafePointer(to: listener) { listenerPtr in
            _ = wl_seat_add_listener(pointer, listenerPtr, box.opaque)
        }
    }
}

private struct WlSeatListenerHandlers: @unchecked Sendable {
    let capabilities: @Sendable (UInt32) -> Void
    let name: @Sendable (String) -> Void
}

private let seatCapabilitiesTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UInt32) -> Void = { data, _, caps in
    guard let handlers = CBridge<WlSeatListenerHandlers>.load(data)?.payload else { return }
    handlers.capabilities(caps)
}

private let seatNameTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UnsafePointer<CChar>?) -> Void = { data, _, nameCStr in
    guard let handlers = CBridge<WlSeatListenerHandlers>.load(data)?.payload else { return }
    guard let nameCStr = nameCStr else { return }
    handlers.name(String(cString: nameCStr))
}