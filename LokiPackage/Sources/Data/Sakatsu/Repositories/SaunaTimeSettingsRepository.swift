public protocol SaunaTimeSettingsRepository {
    func defaultSaunaTimes() throws -> DefaultSaunaTimes
    func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) throws
}

public final class DefaultSaunaTimeSettingsRepository {
    public static let shared = DefaultSaunaTimeSettingsRepository()

    private let localDataSource: any SaunaTimeSettingsLocalDataSource

    private init(
        localDataSource: some SaunaTimeSettingsLocalDataSource = SaunaTimeSettingsUserDefaultsDataSource.shared
    ) {
        self.localDataSource = localDataSource
    }
}

extension DefaultSaunaTimeSettingsRepository: SaunaTimeSettingsRepository {
    public func defaultSaunaTimes() throws -> DefaultSaunaTimes {
        try localDataSource.defaultSaunaTimes()
    }

    public func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) throws {
        try localDataSource.saveDefaultSaunaTimes(defaultSaunaTimes)
    }
}
