// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Engine",
//    platforms: [.macOS(.v10_15), .macCatalyst(.v13), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
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
        .package(name: "Quick", url: "https://github.com/Quick/Quick", from: "4.0.0"),
        .package(name: "Nimble", url: "https://github.com/Quick/Nimble", from: "9.2.1")
    ],
    targets: [
        .target(name: "Engine"),
        .testTarget(name: "EngineTests", dependencies: ["Engine", "Quick", "Nimble"])
    ]
)
