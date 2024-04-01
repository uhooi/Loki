import UserDefaultsCore

protocol SaunaTimeSettingsLocalDataSource: Sendable {
    func defaultSaunaTimes() async throws -> DefaultSaunaTimes
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
    func defaultSaunaTimes() async throws -> DefaultSaunaTimes {
        do {
            return try await userDefaultsClient.object(forKey: .defaultSaunaTimes)
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
