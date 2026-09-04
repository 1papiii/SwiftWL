import wayland
import Glibc


public final class WlSeatResource {
    public let resource: UnsafeMutablePointer<wl_resource>
    public let name: String
    public var capabilities: UInt32

    private var keyboardResources: [WlKeyboardResource] = []

    public init(resource: UnsafeMutablePointer<wl_resource>, name: String, capabilities: UInt32 = 0) {
        self.resource = resource
        self.name = name
        self.capabilities = capabilities
        sendName()
        sendCapabilities()
    }

    public func sendName() {
        name.withCString { cName in
            wl_seat_send_name(resource, cName)
        }
    }

    public func sendCapabilities() {
        wl_seat_send_capabilities(resource, capabilities)
    }

    public func updateCapabilities(_ newCaps: UInt32) {
        capabilities = newCaps
        sendCapabilities()
    }

    public func createKeyboard(client: OpaquePointer, id: UInt32, keymapFd: Int32, keymapSize: UInt32) -> WlKeyboardResource {
        guard let kbWl = wl_resource_create(client, wl_swift_keyboard_interface(), 1, id) else {
            fatalError("wl_resource_create(keyboard) failed")
        }
        let kb = WlKeyboardResource(resource: kbWl)
        keyboardResources.append(kb)

        let env = UnsafeMutablePointer<wl_swift_keyboard_env>.allocate(capacity: 1)
        env.pointee = wl_swift_keyboard_env(
            swift_context: Unmanaged.passUnretained(kb).toOpaque(),
            state: nil,
            release: keyboardReleaseTrampoline
        )
        wl_swift_set_keyboard_implementation(kbWl, env)

        kb.sendKeymap(fd: keymapFd, size: keymapSize)
        kb.sendRepeatInfo(rate: 25, delay: 500)

        return kb
    }

    public func createPointer(client: OpaquePointer, id: UInt32) {
        _ = wl_resource_create(client, wl_swift_pointer_interface(), 1, id)
    }

    public func createTouch(client: OpaquePointer, id: UInt32) {
        _ = wl_resource_create(client, wl_swift_touch_interface(), 1, id)
    }

    public func release() {
    }
}

private let keyboardReleaseTrampoline: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, OpaquePointer?, UnsafeMutablePointer<wl_resource>?) -> Void = { ctx, _, _, _ in
    guard let ctx = ctx else { return }
    _ = Unmanaged<WlKeyboardResource>.fromOpaque(ctx).takeUnretainedValue()
}
