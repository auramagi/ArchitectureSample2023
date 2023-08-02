// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "WatchUI",
    products: [
        .library(
            name: "WatchUI",
            targets: ["WatchUI"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(name: "WatchUI", dependencies: ["Core"]),
    ]
)
