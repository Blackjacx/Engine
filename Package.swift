// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "Engine",
    platforms: [
        .macOS(.v13),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(name: "Engine", targets: ["Engine"])
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2")
    ],
    targets: [
        .target(
            name: "Engine",
            dependencies: ["KeychainAccess"]
        ),
        .testTarget(
            name: "EngineTests",
            dependencies: ["Engine"]
        )
    ]
)
