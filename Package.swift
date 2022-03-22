// swift-tools-version:5.6
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
    dependencies: [
        .package(url: "https://github.com/Quick/Quick", from: "4.0.0"),
        .package(url: "https://github.com/Quick/Nimble", from: "9.2.1")
    ],
    targets: [
        .target(name: "Engine"),
        .testTarget(name: "EngineTests", dependencies: ["Engine", "Quick", "Nimble"])
    ]
)
