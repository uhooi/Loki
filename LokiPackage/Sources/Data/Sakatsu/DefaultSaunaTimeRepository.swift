import UserDefaultsCore

public protocol DefaultSaunaTimeRepository {
    func defaultSaunaSet() throws -> SaunaSet
    func saveDefaultSaunaSet(_ defaultSaunaSet: SaunaSet) throws
}

public struct DefaultSaunaTimeUserDefaultsClient {
    public static let shared: Self = .init()
    private static let defaultSaunaSetKey = "defaultSaunaSet"

    private let userDefaultsClient = UserDefaultsClient.shared

    private init() {}
}

extension DefaultSaunaTimeUserDefaultsClient: DefaultSaunaTimeRepository {
    public func defaultSaunaSet() throws -> SaunaSet {
        do {
            return try userDefaultsClient.object(forKey: Self.defaultSaunaSetKey)
        } catch UserDefaultsError.missingValue {
            return .init()
        } catch {
            throw error
        }
    }

    public func saveDefaultSaunaSet(_ defaultSaunaSet: SaunaSet) throws {
        try userDefaultsClient.set(defaultSaunaSet, forKey: Self.defaultSaunaSetKey)
    }
}
