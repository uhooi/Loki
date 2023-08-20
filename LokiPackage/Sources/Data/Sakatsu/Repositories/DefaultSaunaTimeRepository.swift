public protocol DefaultSaunaTimeRepository {
    func defaultSaunaTimes() throws -> DefaultSaunaTimes
    func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) throws
}

public final class DefaultDefaultSaunaTimeRepository {
    public static let shared = DefaultDefaultSaunaTimeRepository()

    private let localDataSource: any SaunaTimeSettingsLocalDataSource

    private init(
        localDataSource: some SaunaTimeSettingsLocalDataSource = SaunaTimeSettingsUserDefaultsDataSource.shared
    ) {
        self.localDataSource = localDataSource
    }
}

extension DefaultDefaultSaunaTimeRepository: DefaultSaunaTimeRepository {
    public func defaultSaunaTimes() throws -> DefaultSaunaTimes {
        try localDataSource.defaultSaunaTimes()
    }

    public func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) throws {
        try localDataSource.saveDefaultSaunaTimes(defaultSaunaTimes)
    }
}
