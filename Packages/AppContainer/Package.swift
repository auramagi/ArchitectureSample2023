// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "AppContainer",
    platforms: [.iOS(.v16), .macOS(.v13), .watchOS(.v9)],
    products: [
        .library(
            name: "AppContainer",
            targets: [
                "AppContainer",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(name: "AppContainer", dependencies: [
            .product(name: "Core", package: "Core"),
            .product(name: "AppUI", package: "Core"),
            .product(name: "RealmStorage", package: "Core"),
        ]),
    ]
)
