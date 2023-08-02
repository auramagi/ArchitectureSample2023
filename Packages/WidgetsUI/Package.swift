// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "WidgetsUI",
    products: [
        .library(
            name: "WidgetsUI",
            targets: ["WidgetsUI"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(name: "WidgetsUI", dependencies: ["Core"]),
    ]
)
