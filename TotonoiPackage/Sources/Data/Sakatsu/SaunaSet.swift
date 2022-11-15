import Foundation
import UserDefaultsCore

public protocol SaunaSetItemProtocol {
    var emoji: String { get }
    var title: String? { get set }
    var unit: String { get }
    var time: TimeInterval? { get set }
}

public struct SaunaSet {
    public var sauna: Sauna = .init()
    public var coolBath: CoolBath = .init()
    public var relaxation: Relaxation = .init()
    
    public init() {}
    
    public struct Sauna: SaunaSetItemProtocol {
        public var emoji: String { "🔥" }
        public var title: String? = "サウナ"
        public var unit: String { "分" }
        
        private var _time: TimeInterval? = nil
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
        public var title: String? = "水風呂"
        public var unit: String { "秒" }
        
        public var time: TimeInterval? = nil
    }
    
    public struct Relaxation: SaunaSetItemProtocol {
        public var emoji: String { "🍃" }
        public var title: String? = "休憩"
        public var unit: String { "分" }
        
        private var _time: TimeInterval? = nil
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

extension SaunaSet: Identifiable {
    public var id: UUID { UUID() }
}

extension SaunaSet: UserDefaultsPersistable {}
extension SaunaSet.Sauna: UserDefaultsPersistable {}
extension SaunaSet.CoolBath: UserDefaultsPersistable {}
extension SaunaSet.Relaxation: UserDefaultsPersistable {}

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
