// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "MacUI",
    platforms: [.macOS(.v13)],
    products: [
        .library(
            name: "MacUI",
            targets: ["MacUI"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
//        .package(path: "../AppUI"),
    ],
    targets: [
        .target(name: "MacUI", dependencies: ["Core"]),// "AppUI"]),
    ]
)
