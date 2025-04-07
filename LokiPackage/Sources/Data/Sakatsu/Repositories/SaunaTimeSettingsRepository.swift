package protocol SaunaTimeSettingsRepository: Sendable {
    func defaultSaunaTimes() async throws -> DefaultSaunaTimes
    func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) async throws
}

package final class DefaultSaunaTimeSettingsRepository {
    package static let shared = DefaultSaunaTimeSettingsRepository()

    private let localDataSource: any SaunaTimeSettingsLocalDataSource

    private init(
        localDataSource: some SaunaTimeSettingsLocalDataSource = SaunaTimeSettingsUserDefaultsDataSource.shared,
    ) {
        self.localDataSource = localDataSource
    }
}

extension DefaultSaunaTimeSettingsRepository: SaunaTimeSettingsRepository {
    package func defaultSaunaTimes() async throws -> DefaultSaunaTimes {
        try await localDataSource.defaultSaunaTimes()
    }

    package func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) async throws {
        try await localDataSource.saveDefaultSaunaTimes(defaultSaunaTimes)
    }
}
