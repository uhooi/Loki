package protocol SaunaTimeSettingsRepository: Sendable {
    func defaultSaunaTimes() throws -> DefaultSaunaTimes
    func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) throws
}

package final class DefaultSaunaTimeSettingsRepository {
    package static let shared = DefaultSaunaTimeSettingsRepository()

    private let localDataSource: any SaunaTimeSettingsLocalDataSource

    private init(
        localDataSource: some SaunaTimeSettingsLocalDataSource = SaunaTimeSettingsUserDefaultsDataSource.shared
    ) {
        self.localDataSource = localDataSource
    }
}

extension DefaultSaunaTimeSettingsRepository: SaunaTimeSettingsRepository {
    package func defaultSaunaTimes() throws -> DefaultSaunaTimes {
        try localDataSource.defaultSaunaTimes()
    }

    package func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) throws {
        try localDataSource.saveDefaultSaunaTimes(defaultSaunaTimes)
    }
}
