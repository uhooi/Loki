import Foundation

public typealias UserDefaultsGettable = Decodable
public typealias UserDefaultsSettable = Encodable
public typealias UserDefaultsPersistable = UserDefaultsGettable & UserDefaultsSettable

private enum UserDefaultsError: LocalizedError {
    case gettingFailed(key: String)
    
    var errorDescription: String? {
        switch self {
        case .gettingFailed:
            return "オブジェクトの取得に失敗しました。"
        }
    }
}

public struct UserDefaultsClient {
    public static let shared: Self = .init()
    
    private init() {}
    
    public func object<V: UserDefaultsGettable>(forKey defaultName: String) throws -> V {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = UserDefaults.standard.data(forKey: defaultName) else {
            throw UserDefaultsError.gettingFailed(key: defaultName)
        }
        return try jsonDecoder.decode(V.self, from: data)
    }
    
    public func setObject<V: UserDefaultsSettable>(_ value: V, forKey defaultName: String) throws {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try jsonEncoder.encode(value)
        UserDefaults.standard.set(data, forKey: defaultName)
    }
}
