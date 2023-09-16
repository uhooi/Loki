import Foundation

public protocol SaunaSetItemProtocol {
    var emoji: String { get }
    var title: String { get set }
    var unit: String { get }
    var time: TimeInterval? { get set }
}

public struct SaunaSet: Identifiable {
    public var id = UUID()
    public var sauna: Sauna = .init()
    public var coolBath: CoolBath = .init()
    public var relaxation: Relaxation = .init()

    public init() {}

    public struct Sauna: SaunaSetItemProtocol {
        public var emoji: String { "🔥" }
        public var title = L10n.sauna
        public var unit: String { L10n.m }

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
        public var title = L10n.coolBath
        public var unit: String { L10n.s }

        public var time: TimeInterval?
    }

    public struct Relaxation: SaunaSetItemProtocol {
        public var emoji: String { "🍃" }
        public var title = L10n.relaxation
        public var unit: String { L10n.m }

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
