// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "WatchAppContainer",
    platforms: [.iOS(.v16), .macOS(.v13), .watchOS(.v9)],
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
    ],
    targets: [
        .target(name: "WatchAppContainer", dependencies: [
            .product(name: "Core", package: "Core"),
            .product(name: "WatchUI", package: "Core"),
        ]),
    ]
)
