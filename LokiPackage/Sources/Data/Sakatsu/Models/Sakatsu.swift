import Foundation

public struct Sakatsu: Identifiable {
    public var id = UUID()
    public var facilityName: String = ""
    public var visitingDate: Date = .now
    public var saunaTemperatures: [SaunaTemperature] = [.sauna, .coolBath]
    public var foreword: String?
    public var saunaSets: [SaunaSet] = [.init()]
    public var afterword: String?

    public init() {}

    public init(saunaSets: [SaunaSet]) {
        self.saunaSets = saunaSets
    }
}

extension Sakatsu: Hashable {}

extension Sakatsu: Equatable {
    public static func == (lhs: Sakatsu, rhs: Sakatsu) -> Bool {
        lhs.id == rhs.id
    }
}

extension Sakatsu: Codable {}

#if DEBUG
extension Sakatsu {
    public static var preview: Self {
        var sakatsu = Sakatsu()
        sakatsu.facilityName = "サウナウホーイ"

        var saunaTemperature = SaunaTemperature.sauna
        saunaTemperature.temperature = 92
        var coolBathTemperature = SaunaTemperature.coolBath
        coolBathTemperature.temperature = 15
        sakatsu.saunaTemperatures = [saunaTemperature, coolBathTemperature]

        sakatsu.foreword = "まえがきテスト"
        sakatsu.saunaSets = [.preview, .preview, .preview]
        sakatsu.afterword = "あとがきテスト"

        return sakatsu
    }
}
#endif
