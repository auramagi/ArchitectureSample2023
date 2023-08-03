// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "AppUI",
    platforms: [.iOS(.v16), .macOS(.v13), .watchOS(.v9)],
    products: [
        .library(
            name: "AppUI",
//            type: .dynamic,
            targets: ["AppUI"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(name: "AppUI", dependencies: ["Core"]),
    ]
)
