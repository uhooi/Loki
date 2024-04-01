package protocol SakatsuRepository: Sendable {
    func sakatsus() async throws -> [Sakatsu]
    func saveSakatsus(_ sakatsus: [Sakatsu]) throws
    func makeDefaultSaunaSet() async -> SaunaSet
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
    package func sakatsus() async throws -> [Sakatsu] {
        try await sakatsuDataSource.sakatsus()
    }

    package func saveSakatsus(_ sakatsus: [Sakatsu]) throws {
        try sakatsuDataSource.saveSakatsus(sakatsus)
    }

    package func makeDefaultSaunaSet() async -> SaunaSet {
        do {
            let defaultSaunaTimes = try await saunaTimeSettingsRepository.defaultSaunaTimes()
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
