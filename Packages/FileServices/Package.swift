// swift-tools-version: 6.0
import PackageDescription

// swiftlint:disable:next prefixed_toplevel_constant
let package = Package(
    name: "FileServices",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(name: "FileServices", targets: ["FileServices"])
    ],
    dependencies: [
        .package(path: "../Core")
    ],
    targets: [
        .target(name: "FileServices", dependencies: ["Core"]),
        .testTarget(name: "FileServicesTests", dependencies: ["FileServices"])
    ]
)
