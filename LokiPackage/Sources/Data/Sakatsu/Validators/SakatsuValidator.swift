package import Foundation

package protocol SakatsuValidator {
    func validate(facilityName: String) -> Bool
    func validate(visitingDate: Date) -> Bool
    func validate(foreword: String?) -> Bool
    func validate(saunaTitle: String) -> Bool
    func validate(saunaTime: TimeInterval?) -> Bool
    func validate(coolBathTitle: String) -> Bool
    func validate(coolBathTime: TimeInterval?) -> Bool
    func validate(relaxationTitle: String) -> Bool
    func validate(relaxationTime: TimeInterval?) -> Bool
    func validate(afterword: String?) -> Bool
    func validate(temperatureTitle: String) -> Bool
    func validate(temperature: Decimal?) -> Bool
}

package struct DefaultSakatsuValidator {
    package init() {}
}

extension DefaultSakatsuValidator: SakatsuValidator {
    package func validate(facilityName: String) -> Bool {
        !facilityName.isEmpty
    }

    package func validate(visitingDate: Date) -> Bool {
        true // TODO: Disable future dates
    }

    package func validate(foreword: String?) -> Bool {
        true
    }

    package func validate(saunaTitle: String) -> Bool {
        true
    }

    package func validate(saunaTime: TimeInterval?) -> Bool {
        if let saunaTime {
            (0 <= saunaTime && saunaTime < 1_000)
        } else {
            true
        }
    }

    package func validate(coolBathTitle: String) -> Bool {
        true
    }

    package func validate(coolBathTime: TimeInterval?) -> Bool {
        if let coolBathTime {
            (0 <= coolBathTime && coolBathTime < 1_000)
        } else {
            true
        }
    }

    package func validate(relaxationTitle: String) -> Bool {
        true
    }

    package func validate(relaxationTime: TimeInterval?) -> Bool {
        if let relaxationTime {
            (0 <= relaxationTime && relaxationTime < 1_000)
        } else {
            true
        }
    }

    package func validate(afterword: String?) -> Bool {
        true
    }

    package func validate(temperatureTitle: String) -> Bool {
        true
    }

    package func validate(temperature: Decimal?) -> Bool {
        if let temperature {
            (0 <= temperature && temperature < 1_000)
        } else {
            true
        }
    }
}
