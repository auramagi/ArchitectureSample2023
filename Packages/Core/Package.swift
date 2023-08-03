// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v16), .macOS(.v13), .watchOS(.v9)],
    products: [
        .library(name: "Core", targets: ["Core"]),
        .library(name: "CoreUI", targets: ["CoreUI"]),

        .library(name: "AppUI", targets: ["AppUI"]),
        .library(name: "MacUI", targets: ["MacUI"]),
        .library(name: "WatchUI", targets: ["WatchUI"]),
        .library(name: "WidgetsUI", targets: ["WidgetsUI"]),
        
        .library(name: "RealmStorage", targets: ["RealmStorage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift", from: "10.42.0"),
    ],
    targets: [
        .target(name: "Core"),

        .target(name: "CoreUI", dependencies: ["Core"]),
        .target(name: "AppUI", dependencies: ["Core"]),
        .target(name: "MacUI", dependencies: ["Core", "AppUI"]),
        .target(name: "WatchUI", dependencies: ["Core"]),
        .target(name: "WidgetsUI", dependencies: ["Core"]),

        .target(name: "RealmStorage", dependencies: [
            "Core",
            .product(name: "RealmSwift", package: "realm-swift"),
        ]),
    ]
)
