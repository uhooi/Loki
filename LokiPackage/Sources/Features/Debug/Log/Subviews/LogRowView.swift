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
                            typeIconImage(entry.level.iconName)
                        }

                        if shouldShowTimestamp {
                            metadataText(logDateFormatter.string(from: entry.date))
                        }
                    }

                    if shouldShowLigrary {
                        metadataView(
                            text: entry.library,
                            iconName: Metadata.library.iconName
                        )
                    }

                    if shouldShowPidAndTid {
                        metadataView(
                            text: "\(entry.processIdentifier):\(entry.threadIdentifier)",
                            iconName: Metadata.pidAndTid.iconName
                        )
                    }

                    if shouldShowSubsystem {
                        metadataView(
                            text: entry.subsystem,
                            iconName: Metadata.subsystem.iconName
                        )
                    }

                    if shouldShowCategory {
                        metadataView(
                            text: entry.category,
                            iconName: Metadata.category.iconName
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Privates

private extension LogRowView {
    func metadataView(text: String, iconName: String) -> some View {
        HStack(spacing: 2) {
            Image(systemName: iconName)
                .font(.caption2)
                .foregroundStyle(.secondary)

            metadataText(text)
        }
    }

    func metadataText(_ text: String) -> some View {
        Text(text)
            .font(.caption.bold())
            .foregroundStyle(.secondary)
    }

    func typeIconImage(_ iconName: String) -> some View {
        Image(systemName: iconName)
            .resizable()
            .frame(width: 8, height: 8)
            .foregroundStyle(.white)
            .padding(3)
            .background(entry.level.iconBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 2))
    }
}
