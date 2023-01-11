import Foundation
import UserDefaultsCore

public protocol DefaultSaunaTimeRepository {
    func defaultSaunaTimes() throws -> DefaultSaunaTimes
    func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) throws
}

public struct DefaultSaunaTimeUserDefaultsClient {
    public static let shared: Self = .init()
    private static let defaultSaunaTimesKey = "defaultSaunaTimes"

    private let userDefaultsClient = UserDefaultsClient.shared

    private init() {}
}

extension DefaultSaunaTimeUserDefaultsClient: DefaultSaunaTimeRepository {
    public func defaultSaunaTimes() throws -> DefaultSaunaTimes {
        do {
            return try userDefaultsClient.object(forKey: Self.defaultSaunaTimesKey)
        } catch UserDefaultsError.missingValue {
            return .init()
        } catch {
            throw error
        }
    }

    public func saveDefaultSaunaTimes(_ defaultSaunaTimes: DefaultSaunaTimes) throws {
        try userDefaultsClient.set(defaultSaunaTimes, forKey: Self.defaultSaunaTimesKey)
    }
}
