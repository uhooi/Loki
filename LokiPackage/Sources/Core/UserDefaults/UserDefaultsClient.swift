public protocol UserDefaultsClient {
    func object<V: Decodable>(forKey key: UserDefaultsKey) throws -> V
    func set<V: Encodable>(_ value: V, forKey key: UserDefaultsKey) throws
}
