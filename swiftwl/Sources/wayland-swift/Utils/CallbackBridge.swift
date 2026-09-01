import Foundation

public final class CBridge<Payload: Sendable>: @unchecked Sendable {
    public let payload: Payload

    public init(_ payload: Payload) {
        self.payload = payload
    }


    public var opaque: UnsafeMutableRawPointer {
        Unmanaged.passUnretained(self).toOpaque()
    }


    public static func load(_ data: UnsafeMutableRawPointer?) -> CBridge<Payload>? {
        guard let data = data else { return nil }
        return Unmanaged<CBridge<Payload>>.fromOpaque(data).takeUnretainedValue()
    }
}