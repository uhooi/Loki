import Foundation
import UserDefaultsCore

public struct Sakatsu: Identifiable {
    public var id = UUID()
    public var facilityName: String = ""
    public var visitingDate: Date = .now
    public var foreword: String? = nil
    public var saunaSets: [SaunaSet] = [.init()]
    public var afterword: String? = nil
    
    public init() {}
}

extension Sakatsu: Equatable {
    public static func == (lhs: Sakatsu, rhs: Sakatsu) -> Bool {
        lhs.id == rhs.id
    }
}

extension Sakatsu: UserDefaultsPersistable {}

#if DEBUG
extension Sakatsu {
    public static var preview: Self {
        var sakatsu = Sakatsu()
        sakatsu.facilityName = "サウナウホーイ"
        sakatsu.foreword = "まえがきテスト"
        sakatsu.saunaSets = [.preview, .preview, .preview]
        sakatsu.afterword = "あとがきテスト"
        return sakatsu
    }
}
#endif
