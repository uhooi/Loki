// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "LokiPackage",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v16),
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
//        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.50.3"), // TODO: Use Command Plugins
        .package(url: "https://github.com/uhooi/SwiftLint.git", branch: "feature/add_command_plugin"), // TODO: Remove
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.2"),
    ],
    targets: [
        // Feature layer
        .target(
            name: "SakatsuFeature",
            dependencies: [
                "UICore",
                "SakatsuData",
                .product(name: "Algorithms", package: "swift-algorithms"),
            ],
            path: "./Sources/Features/Sakatsu",
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]),
        .testTarget(
            name: "SakatsuFeatureTests",
            dependencies: ["SakatsuFeature"],
            path: "./Tests/Features/SakatsuTests"),

        // Data layer
        .target(
            name: "SakatsuData",
            dependencies: [
                "UserDefaultsCore",
            ],
            path: "./Sources/Data/Sakatsu",
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]),
        .testTarget(
            name: "SakatsuDataTests",
            dependencies: ["SakatsuData"],
            path: "./Tests/Data/SakatsuTests"),

        // Core layer
        .target(
            name: "UserDefaultsCore",
            dependencies: [],
            path: "./Sources/Core/UserDefaults",
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]),
        .testTarget(
            name: "UserDefaultsCoreTests",
            dependencies: ["UserDefaultsCore"],
            path: "./Tests/Core/UserDefaultsTests"),
        .target(
            name: "UICore",
            dependencies: [],
            path: "./Sources/Core/UI"),
    ]
)
