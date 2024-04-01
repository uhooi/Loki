import Foundation

package protocol UserDefaultsClient: Sendable {
    func object<V: Decodable>(forKey key: UserDefaultsKey) async throws -> V
    func set<V: Encodable>(_ value: V, forKey key: UserDefaultsKey) async throws
}

package final class DefaultUserDefaultsClient: Sendable {
    package static let shared = DefaultUserDefaultsClient()

    private let userDefaults = UserDefaults.standard

    private init() {}
}

extension DefaultUserDefaultsClient: UserDefaultsClient {
    package func object<V: Decodable>(forKey key: UserDefaultsKey) async throws -> V {
        guard let data = userDefaults.data(forKey: key.rawValue) else {
            throw UserDefaultsError.missingValue(key: key)
        }

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(V.self, from: data)
    }

    package func set<V: Encodable>(_ value: V, forKey key: UserDefaultsKey) async throws {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try jsonEncoder.encode(value)
        userDefaults.set(data, forKey: key.rawValue)
    }
}

// The UserDefaults class is thread-safe
// ref: https://developer.apple.com/documentation/foundation/userdefaults#2926903
extension UserDefaults: @unchecked Sendable {}
