import UserDefaultsCore

public protocol SakatsuRepository {
    func sakatsus() async throws -> [Sakatsu]
    func saveSakatsus(_ sakatsus: [Sakatsu]) async throws
}

public struct SakatsuUserDefaultsClient {
    public static let shared: Self = .init()
    private static let sakatsusKey = "sakatsus"
    
    private init() {}
}

extension SakatsuUserDefaultsClient: SakatsuRepository {
    public func sakatsus() async throws -> [Sakatsu] {
        try await UserDefaultsClient.shared.object(forKey: Self.sakatsusKey)
    }
    
    public func saveSakatsus(_ sakatsus: [Sakatsu]) async throws {
        try await UserDefaultsClient.shared.setObject(sakatsus, forKey: Self.sakatsusKey)
    }
}
