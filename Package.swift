// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Engine",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v5),
        .tvOS(.v11)
    ],
    products: [
        .library(name: "Engine", targets: ["Engine"])
    ],
    dependencies: [
        .package(name: "Quick", url: "https://github.com/Quick/Quick", from: "3.0.0"),
        .package(name: "Nimble", url: "https://github.com/Quick/Nimble", from: "9.0.0")
    ],
    targets: [
        .target(name: "Engine"),
        .testTarget(name: "EngineTests", dependencies: ["Engine", "Quick", "Nimble"])
    ]
)
