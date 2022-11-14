import Foundation
import UserDefaultsCore

public struct Sakatsu {
    public static var `default`: Self { .init(
        facilityName: "",
        visitingDate: .now,
        foreword: nil,
        saunaSets: [.null],
        afterword: nil
    )}
    
    public var facilityName: String
    public var visitingDate: Date
    public var foreword: String?
    public var saunaSets: [SaunaSet]
    public var afterword: String?
    
    public init(facilityName: String, visitingDate: Date, foreword: String?, saunaSets: [SaunaSet], afterword: String?) {
        self.facilityName = facilityName
        self.visitingDate = visitingDate
        self.foreword = foreword
        self.saunaSets = saunaSets
        self.afterword = afterword
    }
}

extension Sakatsu: Identifiable {
    public var id: String { facilityName + visitingDate.formatted() }
}

extension Sakatsu: UserDefaultsPersistable {}

#if DEBUG
extension Sakatsu {
    public static var preview: Self {
        .init(
            facilityName: "サウナウホーイ",
            visitingDate: .now,
            foreword: "まえがきテスト",
            saunaSets: [.preview, .preview, .preview],
            afterword: "あとがきテスト"
        )
    }
}
#endif
