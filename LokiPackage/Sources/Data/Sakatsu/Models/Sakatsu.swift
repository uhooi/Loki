package import Foundation

package struct Sakatsu: Identifiable {
    package let id: UUID
    package var facilityName: String = ""
    package var visitingDate: Date = .now
    package var saunaTemperatures: [SaunaTemperature] = [.sauna, .coolBath]
    package var foreword: String?
    package var saunaSets: [SaunaSet] = [.init()]
    package var afterword: String?

    package init() {
        self.id = UUID()
    }

    package init(saunaSets: [SaunaSet]) {
        self.id = UUID()
        self.saunaSets = saunaSets
    }
}

extension Sakatsu: Equatable {
    package static func == (lhs: Sakatsu, rhs: Sakatsu) -> Bool {
        lhs.id == rhs.id
    }
}

extension Sakatsu: Codable {}

#if DEBUG
extension Sakatsu {
    package static var preview: Self {
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
