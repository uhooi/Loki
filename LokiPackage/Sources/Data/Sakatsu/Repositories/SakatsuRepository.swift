import UserDefaultsCore

public protocol SakatsuRepository {
    func sakatsus() throws -> [Sakatsu]
    func saveSakatsus(_ sakatsus: [Sakatsu]) throws
    func makeDefaultSaunaSet() -> SaunaSet
}

public final class DefaultSakatsuRepository {
    public static let shared = DefaultSakatsuRepository()

    private let localDataSource: any UserDefaultsClient
    private let saunaTimeSettingsRepository: any SaunaTimeSettingsRepository

    private init(
        localDataSource: some UserDefaultsClient = DefaultUserDefaultsClient.shared,
        defaultSaunaTimeRepository: some SaunaTimeSettingsRepository = DefaultSaunaTimeSettingsRepository.shared
    ) {
        self.localDataSource = localDataSource
        self.saunaTimeSettingsRepository = defaultSaunaTimeRepository
    }
}

extension DefaultSakatsuRepository: SakatsuRepository {
    public func sakatsus() throws -> [Sakatsu] {
        do {
            return try localDataSource.object(forKey: .sakatsus)
        } catch UserDefaultsError.missingValue {
            return []
        } catch {
            throw error
        }
    }

    public func saveSakatsus(_ sakatsus: [Sakatsu]) throws {
        try localDataSource.set(sakatsus, forKey: .sakatsus)
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
