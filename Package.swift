// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftWL",
    products: [

        .library(
            name: "wayland-swift",
            targets: ["wayland-swift"]
        ),

        .executable(
            name: "swiftwl",
            targets: ["swiftwl"]
        ),
    ],
    targets: [
        .target(
            name: "wayland",
            path: "Sources/wayland",
            publicHeadersPath: "include",
            linkerSettings: [
                .linkedLibrary("wayland-client"),
                .linkedLibrary("wayland-server"),
                .linkedLibrary("wayland-cursor"),
                .linkedLibrary("wayland-egl"),
                .linkedLibrary("xkbcommon"),
            ]
        ),
        .target(
            name: "wayland-swift",
            dependencies: ["wayland"]
        ),
        .testTarget(
            name: "swiftwlTests",
            dependencies: ["wayland-swift", "wayland"]
        ),
        .executableTarget(
            name: "swiftwl",
            dependencies: ["wayland-swift", "wayland"],
            path: "Sources/TinySwiftWL"
        ),
    ],
    swiftLanguageModes: [.v6]
)
