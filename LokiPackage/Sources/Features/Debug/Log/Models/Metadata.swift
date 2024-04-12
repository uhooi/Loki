enum Metadata: CaseIterable, Identifiable {
    case type
    case timestamp
    case library
    case pidAndTid
    case subsystem
    case category

    var id: Self { self }
}

// MARK: - Internals

extension Metadata {
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

    var iconName: String {
        switch self {
        case .type: ""
        case .timestamp: ""
        case .library: "building.columns"
        case .pidAndTid: "tag"
        case .subsystem: "gearshape.2"
        case .category: "square.grid.3x3"
        }
    }
}
