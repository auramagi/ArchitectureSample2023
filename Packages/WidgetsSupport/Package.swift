// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "WidgetsSupport",
    platforms: [.iOS(.v16), .watchOS(.v9)],
    products: [
        .library(
            name: "WidgetsSupport",
            targets: [
                "WidgetsSupport",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(name: "WidgetsUI", dependencies: ["Core"]),
        .target(name: "WidgetsSupport", dependencies: ["Core", "WidgetsUI"]),
    ]
)
