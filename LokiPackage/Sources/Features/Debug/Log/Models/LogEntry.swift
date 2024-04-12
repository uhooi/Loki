import Foundation

struct LogEntry: Sendable {
    let message: String
    let date: Date
    let library: String
    let processIdentifier: String
    let threadIdentifier: String
    let category: String
    let subsystem: String
    let level: LogLevel
}
