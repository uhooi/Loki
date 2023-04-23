import Foundation

public enum UserDefaultsError: LocalizedError {
    case missingValue(key: UserDefaultsKey)

    public var errorDescription: String? {
        switch self {
        case .missingValue:
            return L10n.valueDoesNotExistForTheKey
        }
    }
}

public final class UserDefaultsClient {
    public static let shared = UserDefaultsClient()

    private let userDefaults = UserDefaults.standard

    private init() {}
}

extension UserDefaultsClient {
    public func object<V: Decodable>(forKey key: UserDefaultsKey) throws -> V {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = userDefaults.data(forKey: key.rawValue) else {
            throw UserDefaultsError.missingValue(key: key)
        }
        return try jsonDecoder.decode(V.self, from: data)
    }

    public func set<V: Encodable>(_ value: V, forKey key: UserDefaultsKey) throws {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try jsonEncoder.encode(value)
        userDefaults.set(data, forKey: key.rawValue)
    }
}
