import Foundation

package enum UserDefaultsError: LocalizedError {
    case missingValue(key: UserDefaultsKey)

    package var errorDescription: String? {
        switch self {
        case .missingValue: String(localized: "Value does not exist for the key.", bundle: .module)
        }
    }
}
