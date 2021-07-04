// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Engine",
    platforms: [
        .macOS("12"),
        .iOS("15"),
        .tvOS("15"),
        .watchOS("8")
    ],
    products: [
        .library(name: "Engine", targets: ["Engine"])
    ],
    dependencies: [
        .package(name: "Quick", url: "https://github.com/Quick/Quick", from: "3.1.2"),
        .package(name: "Nimble", url: "https://github.com/Quick/Nimble", from: "9.0.0")
    ],
    targets: [
        .target(name: "Engine"),
        .testTarget(name: "EngineTests", dependencies: ["Engine", "Quick", "Nimble"])
    ]
)
