import UserDefaultsCore

public protocol SakatsuRepository {
    func sakatsus() throws -> [Sakatsu]
    func saveSakatsus(_ sakatsus: [Sakatsu]) throws
    func makeDefaultSaunaSet() -> SaunaSet
}

public final class SakatsuUserDefaultsClient {
    public static let shared = SakatsuUserDefaultsClient()

    private let userDefaultsClient = UserDefaultsClient.shared

    private let defaultSaunaTimeRepository: any DefaultSaunaTimeRepository

    private init(defaultSaunaTimeRepository: some DefaultSaunaTimeRepository = DefaultSaunaTimeUserDefaultsClient.shared) {
        self.defaultSaunaTimeRepository = defaultSaunaTimeRepository
    }
}

extension SakatsuUserDefaultsClient: SakatsuRepository {
    public func sakatsus() throws -> [Sakatsu] {
        do {
            return try userDefaultsClient.object(forKey: .sakatsus)
        } catch UserDefaultsError.missingValue {
            return []
        } catch {
            throw error
        }
    }

    public func saveSakatsus(_ sakatsus: [Sakatsu]) throws {
        try userDefaultsClient.set(sakatsus, forKey: .sakatsus)
    }

    public func makeDefaultSaunaSet() -> SaunaSet {
        do {
            let defaultSaunaTimes = try defaultSaunaTimeRepository.defaultSaunaTimes()
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
