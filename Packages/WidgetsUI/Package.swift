// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "WidgetsUI",
    platforms: [.iOS(.v16), .macOS(.v13), .watchOS(.v9)],
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
