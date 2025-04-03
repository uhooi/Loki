// swift-tools-version: 6.1

import PackageDescription

let debugOtherSwiftFlags = [
    "-Xfrontend", "-warn-long-expression-type-checking=500",
    "-Xfrontend", "-warn-long-function-bodies=500",
    "-strict-concurrency=complete",
    "-enable-actor-data-race-checks",
]

let debugSwiftSettings: [PackageDescription.SwiftSetting] = [
    .unsafeFlags(debugOtherSwiftFlags, .when(configuration: .debug)),
    .enableUpcomingFeature("ExistentialAny", .when(configuration: .debug)), // SE-0335
    .enableUpcomingFeature("InternalImportsByDefault", .when(configuration: .debug)), // SE-0409
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
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0"),
        .package(url: "https://github.com/uhooi/Logdog.git", from: "0.3.0"),
        .package(url: "https://github.com/playbook-ui/playbook-ios.git", from: "0.4.1"),

        // Plugins
        .package(url: "https://github.com/maiyama18/LicensesPlugin", from: "0.2.0"),
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
                .product(name: "Playbook", package: "playbook-ios"),
                .product(name: "PlaybookUI", package: "playbook-ios"),
            ],
            path: "./Sources/Apps/Catalog"),

        // Feature layer
        .target(
            name: "SakatsuFeature",
            dependencies: [
                "SakatsuData",
                "UICore",
                .product(name: "Algorithms", package: "swift-algorithms"),
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
                .plugin(name: "LicensesPlugin", package: "LicensesPlugin"),
            ]),
        .target(
            name: "DebugFeature",
            dependencies: [
                .product(name: "LogdogUI", package: "Logdog"),
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
