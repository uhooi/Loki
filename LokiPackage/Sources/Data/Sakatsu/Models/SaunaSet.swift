import Foundation

public protocol SaunaSetItemProtocol {
    var emoji: String { get }
    var title: String { get set }
    var unit: String { get }
    var time: TimeInterval? { get set }
}

public struct SaunaSet: Identifiable {
    public let id: UUID
    public var sauna: Sauna = .init()
    public var coolBath: CoolBath = .init()
    public var relaxation: Relaxation = .init()

    public init() {
        self.id = UUID()
    }

    public struct Sauna: SaunaSetItemProtocol {
        public var emoji: String { "🔥" }
        public var title: String = .init(localized: "Sauna", bundle: .module)
        public var unit: String { .init(localized: "m", bundle: .module) }

        private var _time: TimeInterval?
        public var time: TimeInterval? {
            get {
                _time.map { $0 / 60 }
            }
            set {
                _time = newValue.map { $0 * 60 }
            }
        }
    }

    public struct CoolBath: SaunaSetItemProtocol {
        public var emoji: String { "💧" }
        public var title: String = .init(localized: "Cool bath", bundle: .module)
        public var unit: String { .init(localized: "s", bundle: .module) }

        public var time: TimeInterval?
    }

    public struct Relaxation: SaunaSetItemProtocol {
        public var emoji: String { "🍃" }
        public var title: String = .init(localized: "Relaxation", bundle: .module)
        public var unit: String { .init(localized: "m", bundle: .module) }

        private var _time: TimeInterval?
        public var time: TimeInterval? {
            get {
                _time.map { $0 / 60 }
            }
            set {
                _time = newValue.map { $0 * 60 }
            }
        }
    }
}

extension SaunaSet: Hashable {}
extension SaunaSet.Sauna: Hashable {}
extension SaunaSet.CoolBath: Hashable {}
extension SaunaSet.Relaxation: Hashable {}

extension SaunaSet: Codable {}
extension SaunaSet.Sauna: Codable {}
extension SaunaSet.CoolBath: Codable {}
extension SaunaSet.Relaxation: Codable {}

#if DEBUG
extension SaunaSet {
    public static var preview: Self {
        var saunaSet = SaunaSet()
        saunaSet.sauna.time = 5
        saunaSet.coolBath.time = 30
        saunaSet.relaxation.time = 10
        return saunaSet
    }
}
#endif
