import SwiftUI
import OSLog

enum LogLevel {
    case undefined
    case debug
    case info
    case notice
    case error
    case fault

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
    var iconName: String {
        switch self {
        case .undefined: "circle.fill"
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
