import Foundation

public typealias UserDefaultsGettable = Decodable
public typealias UserDefaultsSettable = Encodable
public typealias UserDefaultsPersistable = UserDefaultsGettable & UserDefaultsSettable

public struct UserDefaultsClient {
    public static let shared: Self = .init()
    
    private init() {}
    
    public func object<V: UserDefaultsGettable>(forKey defaultName: String) throws -> V {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = UserDefaults.standard.data(forKey: defaultName) else {
            throw NSError(domain: "TODO", code: 0) // TODO: Throw error
        }
        return try jsonDecoder.decode(V.self, from: data)
    }
    
    public func setObject<V: UserDefaultsSettable>(_ value: V, forKey defaultName: String) throws {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(value) else {
            return // TODO: Throw error
        }
        UserDefaults.standard.set(data, forKey: defaultName)
    }
}
