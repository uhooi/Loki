package import Foundation

package struct DefaultSaunaTimes {
    package var saunaTime: TimeInterval?
    package var coolBathTime: TimeInterval?
    package var relaxationTime: TimeInterval?

    package init() {
        self.saunaTime = nil
        self.coolBathTime = nil
        self.relaxationTime = nil
    }
}

extension DefaultSaunaTimes: Codable {}

#if DEBUG
extension DefaultSaunaTimes {
    package static var preview: Self {
        var defaultSaunaTimes = DefaultSaunaTimes()
        defaultSaunaTimes.saunaTime = 6 * 60
        defaultSaunaTimes.coolBathTime = 30
        defaultSaunaTimes.relaxationTime = 10 * 60
        return defaultSaunaTimes
    }
}
#endif
