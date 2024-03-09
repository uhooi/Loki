import Foundation
import os

package enum Logger {
    // The Logger class is thread-safe.
    // ref: https://developer.apple.com/forums/thread/747816
    nonisolated(unsafe) package static let standard: os.Logger = .init(
        subsystem: Bundle.main.bundleIdentifier!,
        category: LogCategory.standard.rawValue
    )
}

// MARK: - Privates

private enum LogCategory: String {
    case standard = "Standard"
}
