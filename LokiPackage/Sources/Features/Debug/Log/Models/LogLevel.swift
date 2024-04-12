import SwiftUI
import OSLog

enum LogLevel: Int, CaseIterable {
    case undefined = 0
    case debug = 1
    case info = 2
    case notice = 3
    case error = 4
    case fault = 5

    init(osLogLevel: OSLogEntryLog.Level) {
        self = switch osLogLevel {
        case .undefined: .undefined
        case .debug: .debug
        case .info: .info
        case .notice: .notice
        case .error: .error
        case .fault: .fault
        @unknown default: .undefined
        }
    }
}

// MARK: - Internals

extension LogLevel {
    var text: String {
        switch self {
        case .undefined: .init(localized: "Undefined", bundle: .module)
        case .debug: .init(localized: "Debug", bundle: .module)
        case .info: .init(localized: "Info", bundle: .module)
        case .notice: .init(localized: "Notice", bundle: .module)
        case .error: .init(localized: "Error", bundle: .module)
        case .fault: .init(localized: "Fault", bundle: .module)
        }
    }

    var iconName: String {
        switch self {
        case .undefined: ""
        case .debug: "stethoscope"
        case .info: "info"
        case .notice: "bell.fill"
        case .error: "exclamationmark.2"
        case .fault: "exclamationmark.3"
        }
    }

    var iconBackgroundColor: Color {
        switch self {
        case .undefined: .secondary
        case .debug: .gray
        case .info: .blue
        case .notice: .gray
        case .error: .yellow
        case .fault: .red
        }
    }

    var backgroundColor: Color {
        switch self {
        case .undefined: .clear
        case .debug: .clear
        case .info: .clear
        case .notice: .clear
        case .error: .yellow.opacity(0.1)
        case .fault: .red.opacity(0.1)
        }
    }
}
