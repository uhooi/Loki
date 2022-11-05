import Foundation

public struct Sakatsu {
    public static let empty: Self = .init(facilityName: "", visitingDate: .now, saunaSets: [.empty], comment: nil)
    
    public var facilityName: String
    public var visitingDate: Date
    public var saunaSets: [SaunaSet]
    public var comment: String?
    
    public init(facilityName: String, visitingDate: Date, saunaSets: [SaunaSet], comment: String?) {
        self.facilityName = facilityName
        self.visitingDate = visitingDate
        self.saunaSets = saunaSets
        self.comment = comment
    }
}

extension Sakatsu: Identifiable {
    public var id: String { facilityName + visitingDate.formatted() }
}

// For save UserDefaults
extension Sakatsu: Codable {}

#if DEBUG
extension Sakatsu {
    public static let preview: Self = .init(
        facilityName: "サウナウホーイ",
        visitingDate: .now,
        saunaSets: [.preview, .preview, .preview],
        comment: "コメントテスト"
    )
}
#endif
