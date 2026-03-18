// swift-tools-version: 6.0
import PackageDescription

// swiftlint:disable:next prefixed_toplevel_constant
let package = Package(
    name: "Core",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(name: "Core", targets: ["Core"])
    ],
    targets: [
        .target(name: "Core"),
        .testTarget(name: "CoreTests", dependencies: ["Core"])
    ]
)
