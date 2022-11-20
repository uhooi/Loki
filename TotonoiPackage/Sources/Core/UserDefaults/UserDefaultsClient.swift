import Foundation

public typealias UserDefaultsGettable = Decodable
public typealias UserDefaultsSettable = Encodable
public typealias UserDefaultsPersistable = UserDefaultsGettable & UserDefaultsSettable

public enum UserDefaultsError: LocalizedError {
    case missingValue(key: String)
    
    public var errorDescription: String? {
        switch self {
        case .missingValue:
            return "対象のキーに値が存在しません。"
        }
    }
}

public struct UserDefaultsClient {
    public static let shared: Self = .init()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    public func object<V: UserDefaultsGettable>(forKey defaultName: String) throws -> V {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = userDefaults.data(forKey: defaultName) else {
            throw UserDefaultsError.missingValue(key: defaultName)
        }
        return try jsonDecoder.decode(V.self, from: data)
    }
    
    public func set<V: UserDefaultsSettable>(_ value: V, forKey defaultName: String) throws {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try jsonEncoder.encode(value)
        userDefaults.set(data, forKey: defaultName)
    }
}
