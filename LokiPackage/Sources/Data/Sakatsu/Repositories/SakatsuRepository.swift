public protocol SakatsuRepository {
    func sakatsus() throws -> [Sakatsu]
    func saveSakatsus(_ sakatsus: [Sakatsu]) throws
    func makeDefaultSaunaSet() -> SaunaSet
}

public final class DefaultSakatsuRepository {
    public static let shared = DefaultSakatsuRepository()

    private let sakatsuDataSource: any SakatsuDataSource
    private let saunaTimeSettingsRepository: any SaunaTimeSettingsRepository

    private init(
        sakatsuDataSource: some SakatsuDataSource = SakatsuUserDefaultsDataSource.shared,
        defaultSaunaTimeRepository: some SaunaTimeSettingsRepository = DefaultSaunaTimeSettingsRepository.shared
    ) {
        self.sakatsuDataSource = sakatsuDataSource
        self.saunaTimeSettingsRepository = defaultSaunaTimeRepository
    }
}

extension DefaultSakatsuRepository: SakatsuRepository {
    public func sakatsus() throws -> [Sakatsu] {
        try sakatsuDataSource.sakatsus()
    }

    public func saveSakatsus(_ sakatsus: [Sakatsu]) throws {
        try sakatsuDataSource.saveSakatsus(sakatsus)
    }

    public func makeDefaultSaunaSet() -> SaunaSet {
        do {
            let defaultSaunaTimes = try saunaTimeSettingsRepository.defaultSaunaTimes()
            var defaultSaunaSet = SaunaSet()
            defaultSaunaSet.sauna.time = defaultSaunaTimes.saunaTime
            defaultSaunaSet.coolBath.time = defaultSaunaTimes.coolBathTime
            defaultSaunaSet.relaxation.time = defaultSaunaTimes.relaxationTime
            return defaultSaunaSet
        } catch {
            return .init()
        }
    }
}
