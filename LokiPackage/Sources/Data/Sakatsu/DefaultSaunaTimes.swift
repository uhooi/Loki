import Foundation

public struct DefaultSaunaTimes {
    public var saunaTime: TimeInterval?
    public var coolBathTime: TimeInterval?
    public var relaxationTime: TimeInterval?
    
    public init() {
        self.saunaTime = nil
        self.coolBathTime = nil
        self.relaxationTime = nil
    }
}

extension DefaultSaunaTimes: Codable {}

#if DEBUG
extension DefaultSaunaTimes {
    public static var preview: Self {
        var defaultSaunaTimes = DefaultSaunaTimes()
        defaultSaunaTimes.saunaTime = 6 * 60
        defaultSaunaTimes.coolBathTime = 30
        defaultSaunaTimes.relaxationTime = 10 * 60
        return defaultSaunaTimes
    }
}
#endif
