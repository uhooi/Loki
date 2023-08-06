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
