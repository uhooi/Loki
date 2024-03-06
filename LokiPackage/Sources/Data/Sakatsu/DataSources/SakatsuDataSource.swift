import UserDefaultsCore

protocol SakatsuDataSource: Sendable {
    func sakatsus() throws -> [Sakatsu]
    func saveSakatsus(_ sakatsus: [Sakatsu]) throws
}

final class SakatsuUserDefaultsDataSource {
    static let shared = SakatsuUserDefaultsDataSource()

    private let userDefaultsClient: any UserDefaultsClient

    private init(
        userDefaultsClient: some UserDefaultsClient = DefaultUserDefaultsClient.shared
    ) {
        self.userDefaultsClient = userDefaultsClient
    }
}

extension SakatsuUserDefaultsDataSource: SakatsuDataSource {
    func sakatsus() throws -> [Sakatsu] {
        do {
            return try userDefaultsClient.object(forKey: .sakatsus)
        } catch UserDefaultsError.missingValue {
            return []
        } catch {
            throw error
        }
    }

    func saveSakatsus(_ sakatsus: [Sakatsu]) throws {
        try userDefaultsClient.set(sakatsus, forKey: .sakatsus)
    }
}
