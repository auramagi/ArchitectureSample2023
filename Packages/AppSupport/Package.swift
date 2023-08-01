// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "AppSupport",
    platforms: [.iOS(.v16), .watchOS(.v9)],
    products: [
        .library(
            name: "AppSupport",
            targets: [
                "AppSupport",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(name: "AppUI", dependencies: ["Core"]),
        .target(name: "AppSupport", dependencies: ["Core", "AppUI"]),
    ]
)
