import Foundation

package struct SaunaTemperature: Identifiable {
    package let id: UUID
    package var emoji: String
    package var title: String
    package var temperature: Decimal?

    init(emoji: String, title: String, temperature: Decimal? = nil) {
        self.id = UUID()
        self.emoji = emoji
        self.title = title
        self.temperature = temperature
    }
}

extension SaunaTemperature {
    package static var sauna: Self { .init(emoji: "🔥", title: String(localized: "Sauna", bundle: .module)) }
    package static var coolBath: Self { .init(emoji: "💧", title: String(localized: "Cool bath", bundle: .module)) }
}

extension SaunaTemperature: Codable {}
