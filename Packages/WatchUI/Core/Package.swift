// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v16), .macOS(.v13), .watchOS(.v9)],
    products: [
        .library(
            name: "Core",
            type: .dynamic,
            targets: [
                "Core",
                "CoreUI",
            ]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Core"),
        .target(name: "CoreUI", dependencies: ["Core"]),
    ]
)
