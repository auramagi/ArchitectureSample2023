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
        .package(path: "../AppUI"),
        .package(path: "../MacUI"),
        .package(url: "https://github.com/realm/realm-swift", from: "10.42.0"),
    ],
    targets: [
        .target(name: "AppContainer", dependencies: [
            "Core",
            "AppUI",
            .product(name: "MacUI", package: "MacUI", condition: .when(platforms: [.macOS])),
            .product(name: "RealmSwift", package: "realm-swift"),
        ]),
    ]
)
