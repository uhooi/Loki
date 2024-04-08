import SwiftUI
import OSLog
import LogCore

struct LogScreen: View {
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
                        Image(systemName: Metadata.subsystem.iconName) // swiftlint:disable:this accessibility_label_for_image

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
                        Image(systemName: Metadata.category.iconName) // swiftlint:disable:this accessibility_label_for_image

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

// MARK: - Privates

private extension OSLogEntryLog.Level {
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
