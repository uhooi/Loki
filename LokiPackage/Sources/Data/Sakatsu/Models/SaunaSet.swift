package import Foundation

package protocol SaunaSetItemProtocol {
    var emoji: String { get }
    var title: String { get set }
    var unit: String { get }
    var time: TimeInterval? { get set }
}

package struct SaunaSet: Identifiable {
    package let id: UUID
    package var sauna: Sauna = .init()
    package var coolBath: CoolBath = .init()
    package var relaxation: Relaxation = .init()

    package init() {
        self.id = UUID()
    }

    package struct Sauna: SaunaSetItemProtocol {
        package var emoji: String { "🔥" }
        package var title: String = .init(localized: "Sauna", bundle: .module)
        package var unit: String { .init(localized: "m", bundle: .module) }

        private var _time: TimeInterval?
        package var time: TimeInterval? {
            get {
                _time.map { $0 / 60 }
            }
            set {
                _time = newValue.map { $0 * 60 }
            }
        }
    }

    package struct CoolBath: SaunaSetItemProtocol {
        package var emoji: String { "💧" }
        package var title: String = .init(localized: "Cool bath", bundle: .module)
        package var unit: String { .init(localized: "s", bundle: .module) }

        package var time: TimeInterval?
    }

    package struct Relaxation: SaunaSetItemProtocol {
        package var emoji: String { "🍃" }
        package var title: String = .init(localized: "Relaxation", bundle: .module)
        package var unit: String { .init(localized: "m", bundle: .module) }

        private var _time: TimeInterval?
        package var time: TimeInterval? {
            get {
                _time.map { $0 / 60 }
            }
            set {
                _time = newValue.map { $0 * 60 }
            }
        }
    }
}

extension SaunaSet: Codable {}
extension SaunaSet.Sauna: Codable {}
extension SaunaSet.CoolBath: Codable {}
extension SaunaSet.Relaxation: Codable {}

#if DEBUG
extension SaunaSet {
    package static var preview: Self {
        var saunaSet = SaunaSet()
        saunaSet.sauna.time = 5
        saunaSet.coolBath.time = 30
        saunaSet.relaxation.time = 10
        return saunaSet
    }
}
#endif
