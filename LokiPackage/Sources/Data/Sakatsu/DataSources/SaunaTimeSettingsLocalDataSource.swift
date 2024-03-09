import UserDefaultsCore

protocol SaunaTimeSettingsLocalDataSource: Sendable {
    func defaultSaunaTimes() throws -> DefaultSaunaTimes
    func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) throws
}

final class SaunaTimeSettingsUserDefaultsDataSource {
    static let shared = SaunaTimeSettingsUserDefaultsDataSource()

    private let userDefaultsClient: any UserDefaultsClient

    private init(
        userDefaultsClient: some UserDefaultsClient = DefaultUserDefaultsClient.shared
    ) {
        self.userDefaultsClient = userDefaultsClient
    }
}

extension SaunaTimeSettingsUserDefaultsDataSource: SaunaTimeSettingsLocalDataSource {
    func defaultSaunaTimes() throws -> DefaultSaunaTimes {
        do {
            return try userDefaultsClient.object(forKey: .defaultSaunaTimes)
        } catch UserDefaultsError.missingValue {
            return .init()
        } catch {
            throw error
        }
    }

    func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) throws {
        try userDefaultsClient.set(defaultSaunaTimes, forKey: .defaultSaunaTimes)
    }
}
