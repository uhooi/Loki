import UserDefaultsCore

public struct SaunaTemperature {
    public var emoji: String
    public var title: String
    public var temperature: Float?
}

extension SaunaTemperature {
    public static var sauna: Self { .init(emoji: "🔥", title: "サウナ") }
    public static var coolBath: Self { .init(emoji: "💧", title: "水風呂") }
}

extension SaunaTemperature: UserDefaultsPersistable {}
