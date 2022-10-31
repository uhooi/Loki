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
                "RecordsFeature",
            ]),
    ],
    dependencies: [
    ],
    targets: [
        // Feature layer
        .target(
            name: "RecordsFeature",
            dependencies: [
                "RecordsData",
            ],
            path: "./Sources/Features/Records"),
        .testTarget(
            name: "RecordsFeatureTests",
            dependencies: ["RecordsFeature"],
            path: "./Tests/Features/RecordsTests"),

        // Data layer
        .target(
            name: "RecordsData",
            dependencies: [
                "DatabaseCore",
            ],
            path: "./Sources/Data/Records"),
        .testTarget(
            name: "RecordsDataTests",
            dependencies: ["RecordsData"],
            path: "./Tests/Data/RecordsTests"),

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
