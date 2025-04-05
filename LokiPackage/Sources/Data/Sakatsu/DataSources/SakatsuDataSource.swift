import UserDefaultsCore

protocol SakatsuDataSource: Sendable {
    func sakatsus() async throws -> [Sakatsu]
    func saveSakatsus(_ sakatsus: [Sakatsu]) async throws
}

final class SakatsuUserDefaultsDataSource {
    static let shared = SakatsuUserDefaultsDataSource()

    private let userDefaultsClient: any UserDefaultsClient

    private init(
        userDefaultsClient: some UserDefaultsClient = DefaultUserDefaultsClient.shared,
    ) {
        self.userDefaultsClient = userDefaultsClient
    }
}

extension SakatsuUserDefaultsDataSource: SakatsuDataSource {
    func sakatsus() async throws -> [Sakatsu] {
        do {
            return try await userDefaultsClient.object(forKey: .sakatsus)
        } catch UserDefaultsError.missingValue {
            return []
        } catch {
            throw error
        }
    }

    func saveSakatsus(_ sakatsus: [Sakatsu]) async throws {
        try await userDefaultsClient.set(sakatsus, forKey: .sakatsus)
    }
}
