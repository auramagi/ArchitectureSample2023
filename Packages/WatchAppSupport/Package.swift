// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "WatchAppSupport",
    platforms: [.watchOS(.v9)],
    products: [
        .library(
            name: "WatchAppSupport",
            targets: [
                "WatchAppSupport",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(name: "WatchUI", dependencies: ["Core"]),
        .target(name: "WatchAppSupport", dependencies: ["Core", "WatchUI"]),
    ]
)
