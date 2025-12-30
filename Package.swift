// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Pulse",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "Pulse", targets: ["Pulse"]),
    ],
    targets: [
        .target(
            name: "Pulse",
            path: ".",
            exclude: [
                "insight.md",
                "specification.md",
                "architecture.md",
                "task.md",
                "implementation_plan.md",
                "walkthrough.md"
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
