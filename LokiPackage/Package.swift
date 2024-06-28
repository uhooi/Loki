// swift-tools-version: 6.0
// swiftlint:disable:previous file_name

import PackageDescription

private extension PackageDescription.Target.Dependency {
    static let algorithms: Self = .product(name: "Algorithms", package: "swift-algorithms")
    static let logdogUI: Self = .product(name: "LogdogUI", package: "Logdog")
    static let playbook: Self = .product(name: "Playbook", package: "playbook-ios")
    static let playbookUI: Self = .product(name: "PlaybookUI", package: "playbook-ios")
}

private extension PackageDescription.Target.PluginUsage {
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
    .enableUpcomingFeature("ExistentialAny", .when(configuration: .debug)), // SE-0335
    .enableUpcomingFeature("BareSlashRegexLiterals", .when(configuration: .debug)), // SE-0354
    .enableUpcomingFeature("DeprecateApplicationMain", .when(configuration: .debug)), // SE-0383
    .enableUpcomingFeature("ImportObjcForwardDeclarations", .when(configuration: .debug)), // SE-0384
    .enableUpcomingFeature("DisableOutwardActorInference", .when(configuration: .debug)), // SE-0401
    .enableUpcomingFeature("IsolatedDefaultValues", .when(configuration: .debug)), // SE-0411
    .enableUpcomingFeature("GlobalConcurrency", .when(configuration: .debug)), // SE-0412
    .enableExperimentalFeature("AccessLevelOnImport", .when(configuration: .debug)), // SE-0409
    .enableExperimentalFeature("StrictConcurrency", .when(configuration: .debug)),
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
        .macOS(.v13),
    ],
    products: [
        .library(name: "Production", targets: ["ProductionApp"]),
        .library(name: "Develop", targets: ["DevelopApp"]),
        .library(name: "Catalog", targets: ["CatalogApp"]),
    ],
    dependencies: [
        // Libraries
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0"),
        .package(url: "https://github.com/uhooi/Logdog.git", from: "0.3.0"),
        .package(url: "https://github.com/playbook-ui/playbook-ios.git", from: "0.3.2"),

        // Plugins
        .package(url: "https://github.com/maiyama18/LicensesPlugin", from: "0.1.5"),
    ],
    targets: [
        // App layer
        .target(
            name: "ProductionApp",
            dependencies: productionFeatures,
            path: "./Sources/Apps/Production"),
        .target(
            name: "DevelopApp",
            dependencies: productionFeatures + [
                "DebugFeature",
            ],
            path: "./Sources/Apps/Develop"),
        .target(
            name: "CatalogApp",
            dependencies: productionFeatures + [
                "UICore",
                .playbook,
                .playbookUI,
            ],
            path: "./Sources/Apps/Catalog"),

        // Feature layer
        .target(
            name: "SakatsuFeature",
            dependencies: [
                "SakatsuData",
                "UICore",
                .algorithms,
            ],
            path: "./Sources/Features/Sakatsu"),
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
            path: "./Sources/Features/Settings"),
        .target(
            name: "LicensesFeature",
            dependencies: [
            ],
            path: "./Sources/Features/Licenses",
            plugins: [
                .licenses,
            ]),
        .target(
            name: "DebugFeature",
            dependencies: [
                .logdogUI,
            ],
            path: "./Sources/Features/Debug"),

        // Data layer
        .target(
            name: "SakatsuData",
            dependencies: [
                "UserDefaultsCore",
            ],
            path: "./Sources/Data/Sakatsu"),
        .testTarget(
            name: "SakatsuDataTests",
            dependencies: ["SakatsuData"],
            path: "./Tests/Data/SakatsuTests"),

        // Core layer
        .target(
            name: "LogCore",
            dependencies: [],
            path: "./Sources/Core/Log"),
        .target(
            name: "UserDefaultsCore",
            dependencies: [],
            path: "./Sources/Core/UserDefaults"),
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

for target in package.targets {
    target.swiftSettings = debugSwiftSettings

    if target.name != "LogCore" {
        target.dependencies.append("LogCore")
    }
}
