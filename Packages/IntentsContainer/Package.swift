// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "IntentsContainer",
    platforms: [.iOS(.v16), .watchOS(.v9)],
    products: [
        .library(
            name: "IntentsContainer",
            targets: [
                "IntentsContainer",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(name: "IntentsContainer", dependencies: ["Core"]),
    ]
)
