import Foundation

/// - seeAlso: https://github.com/uhooi/UhooiPicBook/blob/43e68a6a4800ebf6180a80e5cc0824b976f18bb2/Sources/AppModule/Extensions/Foundation/Bundle+String.swift
extension Bundle {
    // swiftlint:disable force_cast
    var version: String { object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String }
    var build: String { object(forInfoDictionaryKey: "CFBundleVersion") as! String }
    // swiftlint:enable force_cast
}
