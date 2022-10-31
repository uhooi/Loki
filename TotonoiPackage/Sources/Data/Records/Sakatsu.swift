import Foundation

public struct Sakatsu {
    public let facilityName: String
    public let visitingDate: Date
    public let saunaSets: [SaunaSet]
    public let comment: String?
    
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

#if DEBUG
extension Sakatsu {
    public static let preview: Self = .init(
        facilityName: "サウナウホーイ",
        visitingDate: .now,
        saunaSets: [SaunaSet.preview],
        comment: "コメントテスト"
    )
}
#endif
