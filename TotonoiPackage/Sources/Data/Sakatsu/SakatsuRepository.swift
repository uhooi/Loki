import UserDefaultsCore

public protocol SakatsuRepository {
    func sakatsus() throws -> [Sakatsu]
    func saveSakatsus(_ sakatsus: [Sakatsu]) throws
}

public struct SakatsuUserDefaultsClient {
    public static let shared: Self = .init()
    private static let sakatsusKey = "sakatsus"
    
    private let userDefaultsClient = UserDefaultsClient.shared
    
    private init() {}
}

extension SakatsuUserDefaultsClient: SakatsuRepository {
    public func sakatsus() throws -> [Sakatsu] {
        try userDefaultsClient.object(forKey: Self.sakatsusKey)
    }
    
    public func saveSakatsus(_ sakatsus: [Sakatsu]) throws {
        try userDefaultsClient.set(sakatsus, forKey: Self.sakatsusKey)
    }
}
