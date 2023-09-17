import Foundation

public struct SaunaTemperature: Identifiable {
    public let id: UUID
    public var emoji: String
    public var title: String
    public var temperature: Decimal?

    init(emoji: String, title: String, temperature: Decimal? = nil) {
        self.id = UUID()
        self.emoji = emoji
        self.title = title
        self.temperature = temperature
    }
}

extension SaunaTemperature: Hashable {}

extension SaunaTemperature {
    public static var sauna: Self { .init(emoji: "🔥", title: String(localized: "Sauna", bundle: .module)) }
    public static var coolBath: Self { .init(emoji: "💧", title: String(localized: "Cool bath", bundle: .module)) }
}

extension SaunaTemperature: Codable {}
