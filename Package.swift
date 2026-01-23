// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Pulse",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .executable(name: "Pulse", targets: ["Pulse"]),
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.23.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.26.0"),
    ],
    targets: [
        .executableTarget(
            name: "Pulse",
            dependencies: [
                .product(name: "GRPC", package: "grpc-swift"),
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
            ],
            path: ".",
            exclude: [
                "docs",
                "README.md",
                "logo.png"
            ],
            sources: [
                "App",
                "Screens",
                "Components",
                "Infrastructure",
                "Models",
                "Animation"
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
