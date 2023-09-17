import Foundation

public enum UserDefaultsError: LocalizedError {
    case missingValue(key: UserDefaultsKey)

    public var errorDescription: String? {
        switch self {
        case .missingValue: String(localized: "Value does not exist for the key.", bundle: .module)
        }
    }
}
