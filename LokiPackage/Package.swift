// swift-tools-version: 5.7

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
        .iOS(.v16),
        .macOS(.v12),
    ],
    products: [
        .library(name: "Production", targets: ["ProductionApp"]),
        .library(name: "Develop", targets: ["DevelopApp"]),
        .library(name: "Catalog", targets: ["CatalogApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0"),
        .package(url: "https://github.com/playbook-ui/playbook-ios.git", from: "0.3.2"),
        //        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.50.3"), // TODO: Use Command Plugins
        .package(url: "https://github.com/uhooi/SwiftLint.git", branch: "feature/add_command_plugin"), // TODO: Remove
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin.git", from: "6.6.2"),
        .package(url: "https://github.com/maiyama18/LicensesPlugin", from: "0.1.0"),
    ],
    targets: [
        // App layer
        .target(
            name: "ProductionApp",
            dependencies: productionFeatures + [
                "UICore",
            ],
            path: "./Sources/Apps/Production",
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))]),
        .target(
            name: "DevelopApp",
            dependencies: productionFeatures + [
                "UICore",
            ],
            path: "./Sources/Apps/Develop",
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))]),
        .target(
            name: "CatalogApp",
            dependencies: productionFeatures + [
                "UICore",
                .playbook,
                .playbookUI,
            ],
            path: "./Sources/Apps/Catalog",
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))]),
        
        // Feature layer
        .target(
            name: "SakatsuFeature",
            dependencies: [
                "SakatsuData",
                "UICore",
                .algorithms,
            ],
            path: "./Sources/Features/Sakatsu",
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))],
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
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))],
            plugins: [
                .swiftgen,
            ]),
        .target(
            name: "LicensesFeature",
            dependencies: [
                "UICore",
            ],
            path: "./Sources/Features/Licenses",
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))],
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
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))],
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
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))],
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
            swiftSettings: [.unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug))]),
    ]
)
