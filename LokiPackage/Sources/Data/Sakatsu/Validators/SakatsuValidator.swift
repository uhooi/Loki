import Foundation

public protocol SakatsuValidatorProtocol {
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

public struct SakatsuValidator {
    public init() {}
}

extension SakatsuValidator: SakatsuValidatorProtocol {
    public func validate(facilityName: String) -> Bool {
        !facilityName.isEmpty
    }

    public func validate(visitingDate: Date) -> Bool {
        true // TODO: Disable future dates
    }

    public func validate(foreword: String?) -> Bool {
        true
    }

    public func validate(saunaTitle: String) -> Bool {
        true
    }

    public func validate(saunaTime: TimeInterval?) -> Bool {
        if let saunaTime {
            return (0 <= saunaTime && saunaTime < 1_000)
        } else {
            return true
        }
    }

    public func validate(coolBathTitle: String) -> Bool {
        true
    }

    public func validate(coolBathTime: TimeInterval?) -> Bool {
        if let coolBathTime {
            return (0 <= coolBathTime && coolBathTime < 1_000)
        } else {
            return true
        }
    }

    public func validate(relaxationTitle: String) -> Bool {
        true
    }

    public func validate(relaxationTime: TimeInterval?) -> Bool {
        if let relaxationTime {
            return (0 <= relaxationTime && relaxationTime < 1_000)
        } else {
            return true
        }
    }

    public func validate(afterword: String?) -> Bool {
        true
    }

    public func validate(temperatureTitle: String) -> Bool {
        true
    }

    public func validate(temperature: Decimal?) -> Bool {
        if let temperature {
            return (0 <= temperature && temperature < 1_000)
        } else {
            return true
        }
    }
}
