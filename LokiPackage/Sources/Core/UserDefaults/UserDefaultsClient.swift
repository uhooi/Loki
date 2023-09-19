import Foundation

package protocol UserDefaultsClient {
    func object<V: Decodable>(forKey key: UserDefaultsKey) throws -> V
    func set<V: Encodable>(_ value: V, forKey key: UserDefaultsKey) throws
}

package final class DefaultUserDefaultsClient {
    package static let shared = DefaultUserDefaultsClient()

    private let userDefaults = UserDefaults.standard

    private init() {}
}

extension DefaultUserDefaultsClient: UserDefaultsClient {
    package func object<V: Decodable>(forKey key: UserDefaultsKey) throws -> V {
        guard let data = userDefaults.data(forKey: key.rawValue) else {
            throw UserDefaultsError.missingValue(key: key)
        }

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(V.self, from: data)
    }

    package func set<V: Encodable>(_ value: V, forKey key: UserDefaultsKey) throws {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try jsonEncoder.encode(value)
        userDefaults.set(data, forKey: key.rawValue)
    }
}
