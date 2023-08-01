// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "IntentsSupport",
    platforms: [.iOS(.v16), .watchOS(.v9)],
    products: [
        .library(
            name: "IntentsSupport",
            targets: [
                "IntentsSupport",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(name: "IntentsSupport", dependencies: ["Core"]),
    ]
)
