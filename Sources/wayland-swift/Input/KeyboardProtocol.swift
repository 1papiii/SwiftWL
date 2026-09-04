import wayland
import Glibc

public final class WlKeyboardResource {
    public let resource: UnsafeMutablePointer<wl_resource>

    public var pressedKeys: Set<UInt32> = []

    public init(resource: UnsafeMutablePointer<wl_resource>) {
        self.resource = resource
    }

    public func sendKeymap(fd: Int32, size: UInt32, format: UInt32 = 1) {
        wl_keyboard_send_keymap(resource, format, fd, size)
    }

    public func sendRepeatInfo(rate: Int32, delay: Int32) {
        wl_keyboard_send_repeat_info(resource, rate, delay)
    }

    public func sendEnter(serial: UInt32, surface: UnsafeMutablePointer<wl_resource>?, keys: [UInt32] = []) {
        var arr = wl_array()
        if !keys.isEmpty {
            let byteSize = keys.count * MemoryLayout<UInt32>.stride
            _ = wl_array_add(&arr, byteSize)
            if let data = arr.data {
                keys.withUnsafeBytes { buf in
                    if let base = buf.baseAddress {
                        _ = memcpy(data, base, byteSize)
                    }
                }
            }
            arr.size = byteSize
        }
        wl_keyboard_send_enter(resource, serial, surface, &arr)
        wl_array_release(&arr)
    }

    public func sendLeave(serial: UInt32, surface: UnsafeMutablePointer<wl_resource>?) {
        wl_keyboard_send_leave(resource, serial, surface)
    }

    public func sendKey(serial: UInt32, time: UInt32, key: UInt32, state: UInt32) {
        wl_keyboard_send_key(resource, serial, time, key, state)
    }

    public func sendModifiers(serial: UInt32, depressed: UInt32, latched: UInt32, locked: UInt32, group: UInt32) {
        wl_keyboard_send_modifiers(resource, serial, depressed, latched, locked, group)
    }

    public func keyReleased(_ keycode: UInt32) {
        pressedKeys.remove(keycode)
    }

    public func keyPressed(_ keycode: UInt32) {
        pressedKeys.insert(keycode)
    }
}
