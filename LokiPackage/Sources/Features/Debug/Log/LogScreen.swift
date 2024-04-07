import SwiftUI
import OSLog
import LogCore

struct LogScreen: View {
    private enum Metadata: CaseIterable, Identifiable {
        case type
        case timestamp
        case library
        case pidAndTid
        case subsystem
        case category

        var id: Self { self }

        var text: String {
            switch self {
            case .type: .init(localized: "Type", bundle: .module)
            case .timestamp: .init(localized: "Timestamp", bundle: .module)
            case .library: .init(localized: "Library", bundle: .module)
            case .pidAndTid: .init(localized: "PID:TID", bundle: .module)
            case .subsystem: .init(localized: "Subsystem", bundle: .module)
            case .category: .init(localized: "Category", bundle: .module)
            }
        }
    }

    private enum SubsystemSearchScope: Hashable {
        case all
        case subsystem(String)

        var text: String {
            switch self {
            case .all: .init(localized: "All", bundle: .module)
            case let .subsystem(subsystem): subsystem
            }
        }
    }

    private enum CategorySearchScope: Hashable {
        case all
        case category(String)

        var text: String {
            switch self {
            case .all: .init(localized: "All", bundle: .module)
            case let .category(category): category
            }
        }
    }

    @State private var entries: [LogEntry] = []
    @State private var subsystems: Set<String> = []
    @State private var subsystemSearchScope: SubsystemSearchScope = .all
    @State private var categories: Set<String> = []
    @State private var categorySearchScope: CategorySearchScope = .all
    @State private var query = ""
    @State private var isPopoverPresented = false
    @State private var selectedMetadata: Set<Metadata> = []
    @State private var isLoading = false

    private let logStore = LogStore()

    private var filteredEntries: [LogEntry] {
        let filteredEntries: [LogEntry] = entries
            .filter {
                switch subsystemSearchScope {
                case .all: true
                case let .subsystem(subsystem): $0.subsystem == subsystem
                }
            }
            .filter {
                switch categorySearchScope {
                case .all: true
                case let .category(category): $0.category == category
                }
            }

        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
        return trimmedQuery.isEmpty ? filteredEntries : filteredEntries.filter { $0.message.range(of: trimmedQuery, options: [.caseInsensitive, .diacriticInsensitive, .widthInsensitive]) != nil }
    }

    private var sortedSubsystems: [String] {
        Array(subsystems)
            .sorted { $0 < $1 }
    }

    private var sortedCategories: [String] {
        Array(categories)
            .sorted { $0 < $1 }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Menu {
                    Picker(selection: $subsystemSearchScope) {
                        Text("All", bundle: .module)
                            .tag(SubsystemSearchScope.all)

                        ForEach(sortedSubsystems, id: \.self) { subsystem in
                            Text(subsystem)
                                .tag(SubsystemSearchScope.subsystem(subsystem))
                        }
                    } label: {
                        Text("Subsystem", bundle: .module)
                    }
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "gearshape.2") // swiftlint:disable:this accessibility_label_for_image

                        Text(subsystemSearchScope.text)
                            .lineLimit(1)
                    }
                }

                Menu {
                    Picker(selection: $categorySearchScope) {
                        Text("All", bundle: .module)
                            .tag(CategorySearchScope.all)

                        ForEach(sortedCategories, id: \.self) { category in
                            Text(category)
                                .tag(CategorySearchScope.category(category))
                        }
                    } label: {
                        Text("Category", bundle: .module)
                    }
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "square.grid.3x3") // swiftlint:disable:this accessibility_label_for_image

                        Text(categorySearchScope.text)
                            .lineLimit(1)
                    }
                }

                Spacer()

                Button {
                    isPopoverPresented = true
                } label: {
                    Image(systemName: "switch.2") // swiftlint:disable:this accessibility_label_for_image
                }
            }
            .padding(.bottom, 8)
            .padding(.horizontal, 8)
            .disabled(isLoading)

            Divider()

            Group {
                if isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(filteredEntries, id: \.date) { entry in
                            LogRowView(
                                entry: entry,
                                shouldShowType: selectedMetadata.contains(.type),
                                shouldShowTimestamp: selectedMetadata.contains(.timestamp),
                                shouldShowLigrary: selectedMetadata.contains(.library),
                                shouldShowPidAndTid: selectedMetadata.contains(.pidAndTid),
                                shouldShowSubsystem: selectedMetadata.contains(.subsystem),
                                shouldShowCategory: selectedMetadata.contains(.category)
                            )
                            .listRowBackground(entry.level.backgroundColor)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle(String(localized: "Log", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query)
        .popover(isPresented: $isPopoverPresented) {
            NavigationStack {
                List(selection: $selectedMetadata) {
                    ForEach(Metadata.allCases) { metadata in
                        Text(metadata.text)
                    }
                }
                .environment(\.editMode, .constant(.active))
                .navigationTitle(String(localized: "Metadata", bundle: .module))
            }
        }
        .task {
            isLoading = true
            do {
                entries = try await logStore.entries()
                subsystems = Set(entries.map({ $0.subsystem }))
                categories = Set(entries.map({ $0.category }))
            } catch {
                print(error)
            }
            isLoading = false
        }
    }

    init() {
        Logger.standard.debug("\(#function, privacy: .public)")
        Logger.standard.info("\(#function, privacy: .public)")
        Logger.standard.notice("\(#function, privacy: .public)")
        Logger.standard.error("\(#function, privacy: .public)")
        Logger.standard.fault("\(#function, privacy: .public)")
    }
}

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
                            Image(systemName: "building.columns") // swiftlint:disable:this accessibility_label_for_image
                                .font(.caption2)
                                .foregroundStyle(.secondary)

                            Text(entry.library)
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                        }
                    }

                    if shouldShowPidAndTid {
                        HStack(spacing: 2) {
                            Image(systemName: "tag") // swiftlint:disable:this accessibility_label_for_image
                                .font(.caption2)
                                .foregroundStyle(.secondary)

                            Text("\(entry.processIdentifier):\(entry.threadIdentifier)")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                        }
                    }

                    if shouldShowSubsystem {
                        HStack(spacing: 2) {
                            Image(systemName: "gearshape.2") // swiftlint:disable:this accessibility_label_for_image
                                .font(.caption2)
                                .foregroundStyle(.secondary)

                            Text(entry.subsystem)
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                        }
                    }

                    if shouldShowCategory {
                        HStack(spacing: 2) {
                            Image(systemName: "square.grid.3x3") // swiftlint:disable:this accessibility_label_for_image
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

struct LogEntry: Sendable {
    let message: String
    let date: Date
    let library: String
    let processIdentifier: String
    let threadIdentifier: String
    let category: String
    let subsystem: String
    let level: OSLogEntryLog.Level
}

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

// MARK: - Privates

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

    var backgroundColor: Color {
        switch self {
        case .undefined: .clear
        case .debug: .clear
        case .info: .clear
        case .notice: .clear
        case .error: .yellow.opacity(0.1)
        case .fault: .red.opacity(0.1)
        @unknown default: .clear
        }
    }
}
