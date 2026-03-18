// swift-tools-version: 6.0
import PackageDescription

// swiftlint:disable:next prefixed_toplevel_constant
let package = Package(
    name: "SharedUI",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(name: "SharedUI", targets: ["SharedUI"])
    ],
    dependencies: [
        .package(path: "../Core")
    ],
    targets: [
        .target(name: "SharedUI", dependencies: ["Core"]),
        .testTarget(name: "SharedUITests", dependencies: ["SharedUI"])
    ]
)
