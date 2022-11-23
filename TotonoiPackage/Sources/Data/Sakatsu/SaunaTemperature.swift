import Foundation
import UserDefaultsCore

public struct SaunaTemperature: Identifiable {
    public var id = UUID()
    public var emoji: String
    public var title: String
    public var temperature: Decimal?
}

extension SaunaTemperature {
    public static var sauna: Self { .init(emoji: "🔥", title: "サウナ") }
    public static var coolBath: Self { .init(emoji: "💧", title: "水風呂") }
}

extension SaunaTemperature: Codable {}
