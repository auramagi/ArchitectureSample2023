// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "WatchAppContainer",
    platforms: [.watchOS(.v9)],
    products: [
        .library(
            name: "WatchAppContainer",
            targets: [
                "WatchAppContainer",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../WatchUI"),
    ],
    targets: [
        .target(name: "WatchAppContainer", dependencies: ["Core", "WatchUI"]),
    ]
)
