import UserDefaultsCore

public protocol DefaultSaunaTimeRepository {
    func defaultSaunaTimes() throws -> DefaultSaunaTimes
    func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) throws
}

public final class DefaultSaunaTimeUserDefaultsClient {
    public static let shared = DefaultSaunaTimeUserDefaultsClient()

    private let userDefaultsClient = UserDefaultsDataSource.shared

    private init() {}
}

extension DefaultSaunaTimeUserDefaultsClient: DefaultSaunaTimeRepository {
    public func defaultSaunaTimes() throws -> DefaultSaunaTimes {
        do {
            return try userDefaultsClient.object(forKey: .defaultSaunaTimes)
        } catch UserDefaultsError.missingValue {
            return .init()
        } catch {
            throw error
        }
    }

    public func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) throws {
        try userDefaultsClient.set(defaultSaunaTimes, forKey: .defaultSaunaTimes)
    }
}
