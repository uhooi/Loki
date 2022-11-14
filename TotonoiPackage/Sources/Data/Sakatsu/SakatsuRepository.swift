import UserDefaultsCore

public protocol SakatsuRepository {
    func sakatsus() throws -> [Sakatsu]
    func saveSakatsus(_ sakatsus: [Sakatsu]) throws
}

public struct SakatsuUserDefaultsClient {
    public static let shared: Self = .init()
    private static let sakatsusKey = "sakatsus"
    
    private init() {}
}

extension SakatsuUserDefaultsClient: SakatsuRepository {
    public func sakatsus() throws -> [Sakatsu] {
        try UserDefaultsClient.shared.object(forKey: Self.sakatsusKey)
    }
    
    public func saveSakatsus(_ sakatsus: [Sakatsu]) throws {
        try UserDefaultsClient.shared.setObject(sakatsus, forKey: Self.sakatsusKey)
    }
}
