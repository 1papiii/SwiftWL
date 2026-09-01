import Glibc

public struct WlError: Error, Sendable, CustomStringConvertible {
    public enum Kind: Sendable {

        case cError

        case allocation

        case state
    }

    public let kind: Kind
    public let message: String

    public let errnoValue: Int32?

    public init(kind: Kind = .cError, message: String, errnoValue: Int32? = nil) {
        self.kind = kind
        self.message = message
        self.errnoValue = errnoValue
    }

    public var description: String {
        var text = "WlError[\(kind)]: \(message)"
        if let errnoValue {
            text += " (errno \(errnoValue): \(String(cString: strerror(errnoValue)))"
        }
        return text
    }
}