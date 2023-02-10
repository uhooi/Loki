// swift-tools-version: 5.7

import PackageDescription

let debugOtherSwiftFlags = [
    "-Xfrontend", "-warn-long-expression-type-checking=500",
    "-Xfrontend", "-warn-long-function-bodies=500",
    "-strict-concurrency=complete",
    "-enable-actor-data-race-checks",
]

let package = Package(
    name: "LokiPackage",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "Production",
            targets: ["ProductionApp"]),
        .library(
            name: "Develop",
            targets: ["DevelopApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0"),
        //        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.50.3"), // TODO: Use Command Plugins
        .package(url: "https://github.com/uhooi/SwiftLint.git", branch: "feature/add_command_plugin"), // TODO: Remove
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.2"),
    ],
    targets: [
        // App layer
        .target(
            name: "ProductionApp",
            dependencies: [
                "SakatsuFeature",
                "SettingsFeature",
                "UICore",
            ],
            path: "./Sources/Apps/Production",
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))]),
        .target(
            name: "DevelopApp",
            dependencies: [
                "SakatsuFeature",
                "SettingsFeature",
                "UICore",
            ],
            path: "./Sources/Apps/Develop",
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))]),
        
        // Feature layer
        .target(
            name: "SakatsuFeature",
            dependencies: [
                "SakatsuData",
                "UICore",
                .product(name: "Algorithms", package: "swift-algorithms"),
            ],
            path: "./Sources/Features/Sakatsu",
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]),
        .testTarget(
            name: "SakatsuFeatureTests",
            dependencies: ["SakatsuFeature"],
            path: "./Tests/Features/SakatsuTests"),
        .target(
            name: "SettingsFeature",
            dependencies: [
                "SakatsuData",
                "UICore",
            ],
            path: "./Sources/Features/Settings",
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))],
            plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]),
        
        // Data layer
        .target(
            name: "SakatsuData",
            dependencies: [
                "UserDefaultsCore",
            ],
            path: "./Sources/Data/Sakatsu",
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))],
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
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))],
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
            path: "./Sources/Core/UI",
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))]),
    ]
)
