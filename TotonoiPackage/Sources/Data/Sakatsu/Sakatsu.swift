import Foundation
import UserDefaultsCore

public struct Sakatsu {
    public static var `default`: Self { .init(
        facilityName: "",
        visitingDate: .now,
        saunaSets: [.null],
        afterword: nil
    )}
    
    public var facilityName: String
    public var visitingDate: Date
    public var saunaSets: [SaunaSet]
    public var afterword: String?
    
    public init(facilityName: String, visitingDate: Date, saunaSets: [SaunaSet], afterword: String?) {
        self.facilityName = facilityName
        self.visitingDate = visitingDate
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
            saunaSets: [.preview, .preview, .preview],
            afterword: "あとがきテスト"
        )
    }
}
#endif
