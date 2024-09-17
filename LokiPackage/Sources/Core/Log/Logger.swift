import Foundation
package import struct os.Logger

package enum Logger {
    package static let standard: os.Logger = .init(
        subsystem: Bundle.main.bundleIdentifier!,
        category: LogCategory.standard.rawValue
    )
}

// MARK: - Privates

private enum LogCategory: String {
    case standard = "Standard"
}
