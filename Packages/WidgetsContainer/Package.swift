// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "WidgetsSupport",
    platforms: [.iOS(.v16), .watchOS(.v9)],
    products: [
        .library(
            name: "WidgetsContainer",
            targets: [
                "WidgetsContainer",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../WidgetsUI"),
    ],
    targets: [
        .target(name: "WidgetsContainer", dependencies: ["Core", "WidgetsUI"]),
    ]
)
