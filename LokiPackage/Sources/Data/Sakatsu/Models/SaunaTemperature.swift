import Foundation

public struct SaunaTemperature: Identifiable {
    public var id = UUID()
    public var emoji: String
    public var title: String
    public var temperature: Decimal?
}

extension SaunaTemperature: Hashable {}

extension SaunaTemperature {
    public static var sauna: Self { .init(emoji: "🔥", title: L10n.sauna) }
    public static var coolBath: Self { .init(emoji: "💧", title: L10n.coolBath) }
}

extension SaunaTemperature: Codable {}
