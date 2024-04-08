import Foundation
import OSLog

actor LogStore {
    func entries() throws -> [LogEntry] {
        let store = try OSLogStore(scope: .currentProcessIdentifier)
        let position = store.position(timeIntervalSinceLatestBoot: 1)

        return try store.getEntries(at: position)
            .compactMap { $0 as? OSLogEntryLog }
            .compactMap {
                LogEntry(
                    message: $0.composedMessage,
                    date: $0.date,
                    library: $0.sender,
                    processIdentifier: "\($0.processIdentifier)",
                    threadIdentifier: String(format: "%#llx", $0.threadIdentifier),
                    category: $0.category,
                    subsystem: $0.subsystem,
                    level: $0.level
                )
            }
            .sorted { $0.date < $1.date }
    }
}
