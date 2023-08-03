// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "WatchUI",
    platforms: [.iOS(.v16), .macOS(.v13), .watchOS(.v9)],
    products: [
        .library(
            name: "WatchUI",
            targets: ["WatchUI"]
        ),
    ],
    dependencies: [
        .package(path: "Core"),
    ],
    targets: [
        .target(name: "WatchUI", dependencies: ["Core"]),
    ]
)
