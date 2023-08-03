// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "RealmStorage",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "RealmStorage",
            targets: ["RealmStorage"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(url: "https://github.com/realm/realm-swift", from: "10.42.0"),
    ],
    targets: [
        .target(name: "RealmStorage", dependencies: [
            "Core",
            .product(name: "RealmSwift", package: "realm-swift"),
        ]),
    ]
)
