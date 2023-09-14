import Foundation

public struct SaunaTemperature: Identifiable {
    public var id = UUID()
    public var emoji: String
    public var title: String
    public var temperature: Decimal?
}

extension SaunaTemperature {
    public static var sauna: Self { .init(emoji: "🔥", title: String(localized: "Sauna", bundle: .module)) }
    public static var coolBath: Self { .init(emoji: "💧", title: String(localized: "Cool bath", bundle: .module)) }
}

extension SaunaTemperature: Codable {}
