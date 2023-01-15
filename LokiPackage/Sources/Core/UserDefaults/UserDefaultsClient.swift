import Foundation

public enum UserDefaultsError: LocalizedError {
    case missingValue(key: String)

    public var errorDescription: String? {
        switch self {
        case .missingValue:
            return L10n.valueDoesNotExistForTheKey
        }
    }
}

public struct UserDefaultsClient {
    public static let shared: Self = .init()

    private let userDefaults = UserDefaults.standard

    private init() {}

    public func object<V: Decodable>(forKey defaultName: String) throws -> V {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = userDefaults.data(forKey: defaultName) else {
            throw UserDefaultsError.missingValue(key: defaultName)
        }
        return try jsonDecoder.decode(V.self, from: data)
    }

    public func set<V: Encodable>(_ value: V, forKey defaultName: String) throws {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try jsonEncoder.encode(value)
        userDefaults.set(data, forKey: defaultName)
    }
}
