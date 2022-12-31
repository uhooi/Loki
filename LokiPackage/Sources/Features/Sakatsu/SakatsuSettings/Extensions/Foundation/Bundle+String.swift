import Foundation

/// https://github.com/uhooi/UhooiPicBook/blob/43e68a6a4800ebf6180a80e5cc0824b976f18bb2/Sources/AppModule/Extensions/Foundation/Bundle+String.swift
extension Bundle {
    var version: String {
        guard let version = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("Fail to load Version.")
        }
        return version
    }

    var build: String {
        guard let build = object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            fatalError("Fail to load Build.")
        }
        return build
    }
}
