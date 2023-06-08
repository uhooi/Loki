// swift-tools-version: 5.9

import PackageDescription

private extension PackageDescription.Target.Dependency {
    static let algorithms: Self = .product(name: "Algorithms", package: "swift-algorithms")
    static let playbook: Self = .product(name: "Playbook", package: "playbook-ios")
    static let playbookUI: Self = .product(name: "PlaybookUI", package: "playbook-ios")
}

private extension PackageDescription.Target.PluginUsage {
    static let swiftgen: Self = .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")
    static let licenses: Self = .plugin(name: "LicensesPlugin", package: "LicensesPlugin")
}

let debugOtherSwiftFlags = [
    "-Xfrontend", "-warn-long-expression-type-checking=500",
    "-Xfrontend", "-warn-long-function-bodies=500",
    "-strict-concurrency=complete",
    "-enable-actor-data-race-checks",
]

let debugSwiftSettings: [PackageDescription.SwiftSetting] = [
    .unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug)),
    .enableUpcomingFeature("ConciseMagicFile", .when(configuration: .debug)), // SE-0274
    .enableUpcomingFeature("ForwardTrailingClosures", .when(configuration: .debug)), // SE-0286
//    .enableUpcomingFeature("ExistentialAny", .when(configuration: .debug)), // SE-0335 // TODO: SwiftGen causes build errors.
    .enableUpcomingFeature("BaseSlashRegexLiterals", .when(configuration: .debug)), // SE-0354
]

let productionFeatures: [PackageDescription.Target.Dependency] = [
    "SakatsuFeature",
    "SettingsFeature",
    "LicensesFeature",
]

// MARK: Package

let package = Package(
    name: "LokiPackage",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "Production", targets: ["ProductionApp"]),
        .library(name: "Develop", targets: ["DevelopApp"]),
        .library(name: "Catalog", targets: ["CatalogApp"]),
    ],
    dependencies: [
        // Libraries
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0"),
        .package(url: "https://github.com/playbook-ui/playbook-ios.git", from: "0.3.2"),

        // Plugins
        //        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.50.3"), // TODO: Use Command Plugins
        .package(url: "https://github.com/uhooi/SwiftLint.git", branch: "feature/add_command_plugin"), // TODO: Remove
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin.git", from: "6.6.2"),
        .package(url: "https://github.com/maiyama18/LicensesPlugin", from: "0.1.5"),
    ],
    targets: [
        // App layer
        .target(
            name: "ProductionApp",
            dependencies: productionFeatures,
            path: "./Sources/Apps/Production",
            swiftSettings: debugSwiftSettings),
        .target(
            name: "DevelopApp",
            dependencies: productionFeatures,
            path: "./Sources/Apps/Develop",
            swiftSettings: debugSwiftSettings),
        .target(
            name: "CatalogApp",
            dependencies: productionFeatures + [
                "UICore",
                .playbook,
                .playbookUI,
            ],
            path: "./Sources/Apps/Catalog",
            swiftSettings: debugSwiftSettings),
        
        // Feature layer
        .target(
            name: "SakatsuFeature",
            dependencies: [
                "SakatsuData",
                "UICore",
                .algorithms,
            ],
            path: "./Sources/Features/Sakatsu",
            swiftSettings: debugSwiftSettings,
            plugins: [
                .swiftgen,
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
            swiftSettings: debugSwiftSettings,
            plugins: [
                .swiftgen,
            ]),
        .target(
            name: "LicensesFeature",
            dependencies: [
            ],
            path: "./Sources/Features/Licenses",
            swiftSettings: debugSwiftSettings,
            plugins: [
                .swiftgen,
                .licenses,
            ]),
        
        // Data layer
        .target(
            name: "SakatsuData",
            dependencies: [
                "UserDefaultsCore",
            ],
            path: "./Sources/Data/Sakatsu",
            swiftSettings: debugSwiftSettings,
            plugins: [
                .swiftgen,
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
            swiftSettings: debugSwiftSettings,
            plugins: [
                .swiftgen,
            ]),
        .testTarget(
            name: "UserDefaultsCoreTests",
            dependencies: ["UserDefaultsCore"],
            path: "./Tests/Core/UserDefaultsTests"),
        .target(
            name: "UICore",
            dependencies: [],
            path: "./Sources/Core/UI",
            swiftSettings: debugSwiftSettings),
    ]
)
