import Foundation
import UserDefaultsCore

public struct Sakatsu {
    public var facilityName: String = ""
    public var visitingDate: Date = .now
    public var foreword: String? = nil
    public var saunaSets: [SaunaSet] = [.init()]
    public var afterword: String? = nil
    
    public init() {}
}

extension Sakatsu: Identifiable {
    public var id: String { facilityName + visitingDate.formatted() }
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
