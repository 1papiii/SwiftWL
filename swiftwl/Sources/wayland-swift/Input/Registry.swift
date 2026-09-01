import wayland

public class WlRegistry {
    public let pointer: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public func destroy() {
        wl_registry_destroy(pointer)
    }

    public func setListener(
        global: @escaping @Sendable (UInt32, String, UInt32) -> Void,
        globalRemove: @escaping @Sendable (UInt32) -> Void
    ) {
        let box = CBridge(WlRegistryListenerHandlers(global: global, globalRemove: globalRemove))
        let listener = wl_registry_listener(
            global: registryGlobalTrampoline,
            global_remove: registryGlobalRemoveTrampoline
        )
        withUnsafePointer(to: listener) { listenerPtr in
            _ = wl_registry_add_listener(pointer, listenerPtr, box.opaque)
        }
    }

    public func bind(name: UInt32, interface: UnsafePointer<wl_interface>, version: UInt32) -> OpaquePointer? {
        OpaquePointer(wl_registry_bind(pointer, name, interface, version))
    }
}

private struct WlRegistryListenerHandlers: @unchecked Sendable {
    let global: @Sendable (UInt32, String, UInt32) -> Void
    let globalRemove: @Sendable (UInt32) -> Void
}

private let registryGlobalTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UInt32, UnsafePointer<CChar>?, UInt32) -> Void = { data, _, name, interface, version in
    guard let handlers = CBridge<WlRegistryListenerHandlers>.load(data)?.payload else { return }
    guard let interface = interface else { return }
    handlers.global(name, String(cString: interface), version)
}

private let registryGlobalRemoveTrampoline: @convention(c) (UnsafeMutableRawPointer?, OpaquePointer?, UInt32) -> Void = { data, _, name in
    guard let handlers = CBridge<WlRegistryListenerHandlers>.load(data)?.payload else { return }
    handlers.globalRemove(name)
}