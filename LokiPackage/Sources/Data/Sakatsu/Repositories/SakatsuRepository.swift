package protocol SakatsuRepository: Sendable {
    func sakatsus() throws -> [Sakatsu]
    func saveSakatsus(_ sakatsus: [Sakatsu]) throws
    func makeDefaultSaunaSet() -> SaunaSet
}

package final class DefaultSakatsuRepository {
    package static let shared = DefaultSakatsuRepository()

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
    package func sakatsus() throws -> [Sakatsu] {
        try sakatsuDataSource.sakatsus()
    }

    package func saveSakatsus(_ sakatsus: [Sakatsu]) throws {
        try sakatsuDataSource.saveSakatsus(sakatsus)
    }

    package func makeDefaultSaunaSet() -> SaunaSet {
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
