// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "TotonoiPackage",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "FullApp",
            targets: [
                "SakatsuFeature",
            ]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0"),
    ],
    targets: [
        // Feature layer
        .target(
            name: "SakatsuFeature",
            dependencies: [
                "SakatsuData",
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            path: "./Sources/Features/Sakatsu"),
        .testTarget(
            name: "SakatsuFeatureTests",
            dependencies: ["SakatsuFeature"],
            path: "./Tests/Features/SakatsuTests"),

        // Data layer
        .target(
            name: "SakatsuData",
            dependencies: [
                "DatabaseCore",
            ],
            path: "./Sources/Data/Sakatsu"),
        .testTarget(
            name: "SakatsuDataTests",
            dependencies: ["SakatsuData"],
            path: "./Tests/Data/SakatsuTests"),

        // Core layer
        .target(
            name: "DatabaseCore",
            dependencies: [],
            path: "./Sources/Core/Database"),
        .testTarget(
            name: "DatabaseCoreTests",
            dependencies: ["DatabaseCore"],
            path: "./Tests/Core/DatabaseTests"),
    ]
)
