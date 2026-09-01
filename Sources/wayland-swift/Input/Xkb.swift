import wayland
import Glibc

public class XkbContext {
    public let pointer: OpaquePointer

    public init() {
        guard let ptr = xkb_context_new(XKB_CONTEXT_NO_FLAGS) else {
            fatalError("xkb_context_new() failed")
        }
        self.pointer = ptr
    }

    public func keymapFromNames(
        rules: String? = nil, model: String? = nil,
        layout: String? = nil, variant: String? = nil,
        options: String? = nil
    ) -> XkbKeymap? {
        var names = xkb_rule_names(
            rules: nil, model: nil, layout: nil, variant: nil, options: nil
        )

        let cRules = rules.flatMap { UnsafePointer(strdup($0)) }
        let cModel = model.flatMap { UnsafePointer(strdup($0)) }
        let cLayout = layout.flatMap { UnsafePointer(strdup($0)) }
        let cVariant = variant.flatMap { UnsafePointer(strdup($0)) }
        let cOptions = options.flatMap { UnsafePointer(strdup($0)) }
        names.rules = cRules
        names.model = cModel
        names.layout = cLayout
        names.variant = cVariant
        names.options = cOptions
        defer {
            if let p = cRules { free(UnsafeMutableRawPointer(mutating: p)) }
            if let p = cModel { free(UnsafeMutableRawPointer(mutating: p)) }
            if let p = cLayout { free(UnsafeMutableRawPointer(mutating: p)) }
            if let p = cVariant { free(UnsafeMutableRawPointer(mutating: p)) }
            if let p = cOptions { free(UnsafeMutableRawPointer(mutating: p)) }
        }
        guard let kp = xkb_keymap_new_from_names(pointer, &names, XKB_KEYMAP_COMPILE_NO_FLAGS) else {
            return nil
        }
        return XkbKeymap(kp)
    }

    public func keymapFromString(_ str: String) -> XkbKeymap? {
        guard let kp = str.withCString({ xkb_keymap_new_from_string(pointer, $0, XKB_KEYMAP_FORMAT_TEXT_V1, XKB_KEYMAP_COMPILE_NO_FLAGS) }) else {
            return nil
        }
        return XkbKeymap(kp)
    }

    deinit {
        xkb_context_unref(pointer)
    }
}

public class XkbKeymap {
    public let pointer: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func getAsString() -> String? {
        guard let cstr = xkb_keymap_get_as_string(pointer, XKB_KEYMAP_FORMAT_TEXT_V1) else {
            return nil
        }
        defer { free(UnsafeMutableRawPointer(cstr)) }
        return String(cString: cstr)
    }

    public func createState() -> XkbState {
        XkbState(xkb_state_new(pointer)!)
    }

    public var keycodeOffset: UInt32 {
        xkb_keymap_min_keycode(pointer)
    }

    public func modGetIndex(_ name: String) -> UInt32 {
        name.withCString { xkb_keymap_mod_get_index(pointer, $0) }
    }

    deinit {
        xkb_keymap_unref(pointer)
    }
}

public class XkbState {
    public let pointer: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func updateKey(key: UInt32, pressed: Bool) {
        xkb_state_update_key(pointer, key, pressed ? XKB_KEY_DOWN : XKB_KEY_UP)
    }

    public func serializedMods() -> (depressed: UInt32, latched: UInt32, locked: UInt32, group: UInt32) {
        let depressed = xkb_state_serialize_mods(pointer, XKB_STATE_MODS_DEPRESSED)
        let latched   = xkb_state_serialize_mods(pointer, XKB_STATE_MODS_LATCHED)
        let locked    = xkb_state_serialize_mods(pointer, XKB_STATE_MODS_LOCKED)
        let group     = xkb_state_serialize_layout(pointer, XKB_STATE_LAYOUT_EFFECTIVE)
        return (depressed, latched, locked, group)
    }

    public func keyGetSym(keycode: UInt32) -> UInt32 {
        xkb_state_key_get_one_sym(pointer, keycode)
    }

    public func modIndexActive(idx: UInt32, component: xkb_state_component) -> Bool {
        xkb_state_mod_index_is_active(pointer, idx, component) != 0
    }

    deinit {
        xkb_state_unref(pointer)
    }
}

public func createKeymapFile(_ keymapStr: String) -> (fd: Int32, size: Int32)? {
    let size = Int32(keymapStr.utf8.count)
    var template = Array("/tmp/xkb-keymap-XXXXXX".utf8CString + [0])
    let fd = mkstemp(&template)
    guard fd >= 0 else { return nil }

    template.withUnsafeBufferPointer { buf in
        _ = buf.baseAddress.flatMap { unlink($0) }
    }
    var written: Int32 = 0
    keymapStr.withCString { ptr in
        while written < size {
            let n = write(fd, ptr + Int(written), Int(size - written))
            if n < 0 { break }
            written += Int32(n)
        }
    }
    guard written == size else { close(fd); return nil }
    lseek(fd, 0, SEEK_SET)
    return (fd, size)
}
