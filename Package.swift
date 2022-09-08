// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Engine",
    platforms: [
        .macOS(.v12),
        .macCatalyst(.v15),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(name: "Engine", targets: ["Engine"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Engine"),
        .testTarget(name: "EngineTests", dependencies: ["Engine"])
    ]
)
