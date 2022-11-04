import Foundation

public protocol SakatsuRepository {
    func sakatsus() async throws -> [Sakatsu]
    func saveSakatsus(_ sakatsus: [Sakatsu]) async throws
}

public struct SakatsuUserDefaultsClient {
    public static let shared = Self()
    private static let sakatsusKey = "sakatsus"
    
    private init() {}
}

extension SakatsuUserDefaultsClient: SakatsuRepository {
    public func sakatsus() async throws -> [Sakatsu] {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = UserDefaults.standard.data(forKey: Self.sakatsusKey) else {
            return [] // TODO: Throw error
        }
        return try jsonDecoder.decode([Sakatsu].self, from: data)
    }
    
    public func saveSakatsus(_ sakatsus: [Sakatsu]) async throws {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(sakatsus) else {
            return // TODO: Throw error
        }
        UserDefaults.standard.set(data, forKey: Self.sakatsusKey)
    }
}
