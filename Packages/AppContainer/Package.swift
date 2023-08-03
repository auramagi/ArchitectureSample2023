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
        .package(path: "../RealmStorage"),
        .package(path: "../AppUI"),
        .package(path: "../MacUI"),
    ],
    targets: [
        .target(name: "AppContainer", dependencies: [
            "Core",
            "RealmStorage",
            "AppUI",
            .product(name: "MacUI", package: "MacUI", condition: .when(platforms: [.macOS])),
        ]),
    ]
)
