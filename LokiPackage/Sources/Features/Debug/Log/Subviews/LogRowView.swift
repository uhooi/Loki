import SwiftUI
import OSLog

struct LogRowView: View {
    let entry: LogEntry
    let shouldShowType: Bool
    let shouldShowTimestamp: Bool
    let shouldShowLigrary: Bool
    let shouldShowPidAndTid: Bool
    let shouldShowSubsystem: Bool
    let shouldShowCategory: Bool

    private let logDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSSS"
        formatter.calendar = Calendar.current
        formatter.locale = Locale.current
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.message)
                .monospaced()
                .lineLimit(5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    HStack(spacing: 2) {
                        if shouldShowType {
                            Image(systemName: entry.level.iconName) // swiftlint:disable:this accessibility_label_for_image
                                .resizable()
                                .frame(width: 8, height: 8)
                                .foregroundStyle(.white)
                                .padding(3)
                                .background(entry.level.iconBackgroundColor)
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                        }

                        if shouldShowTimestamp {
                            Text(logDateFormatter.string(from: entry.date))
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                        }
                    }

                    if shouldShowLigrary {
                        HStack(spacing: 2) {
                            Image(systemName: Metadata.library.iconName) // swiftlint:disable:this accessibility_label_for_image
                                .font(.caption2)
                                .foregroundStyle(.secondary)

                            Text(entry.library)
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                        }
                    }

                    if shouldShowPidAndTid {
                        HStack(spacing: 2) {
                            Image(systemName: Metadata.pidAndTid.iconName) // swiftlint:disable:this accessibility_label_for_image
                                .font(.caption2)
                                .foregroundStyle(.secondary)

                            Text("\(entry.processIdentifier):\(entry.threadIdentifier)")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                        }
                    }

                    if shouldShowSubsystem {
                        HStack(spacing: 2) {
                            Image(systemName: Metadata.subsystem.iconName) // swiftlint:disable:this accessibility_label_for_image
                                .font(.caption2)
                                .foregroundStyle(.secondary)

                            Text(entry.subsystem)
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                        }
                    }

                    if shouldShowCategory {
                        HStack(spacing: 2) {
                            Image(systemName: Metadata.category.iconName) // swiftlint:disable:this accessibility_label_for_image
                                .font(.caption2)
                                .foregroundStyle(.secondary)

                            Text(entry.category)
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Privates

private extension LogRowView {
}

private extension OSLogEntryLog.Level {
    var iconName: String {
        switch self {
        case .undefined: "circle.fill"
        case .debug: "stethoscope"
        case .info: "info"
        case .notice: "bell.fill"
        case .error: "exclamationmark.2"
        case .fault: "exclamationmark.3"
        @unknown default: "circle.fill"
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
        @unknown default: .secondary
        }
    }
}
