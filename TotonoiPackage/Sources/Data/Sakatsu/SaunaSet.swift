import Foundation
import UserDefaultsCore

public protocol SaunaSetItemProtocol {
    var emoji: String { get }
    var title: String? { get set }
    var unit: String { get }
    var time: TimeInterval? { get set }
}

public struct SaunaSet {
    public static var null: Self { .init(sauna: .null, coolBath: .null, relaxation: .null) }
    
    public var sauna: Sauna
    public var coolBath: CoolBath
    public var relaxation: Relaxation
    
    public init(sauna: Sauna, coolBath: CoolBath, relaxation: Relaxation) {
        self.sauna = sauna
        self.coolBath = coolBath
        self.relaxation = relaxation
    }
    
    public struct Sauna: SaunaSetItemProtocol {
        static var null: Self { .init(time: nil) }
        
        public var emoji: String { "🔥" }
        public var title: String? = "サウナ"
        public var unit: String { "分" }
        
        private var _time: TimeInterval?
        public var time: TimeInterval? {
            get {
                _time.map { $0 / 60 }
            }
            set {
                _time = newValue.map { $0 * 60 }
            }
        }
        
        public init(time: TimeInterval?) {
            self.time = time
        }
    }
    
    public struct CoolBath: SaunaSetItemProtocol {
        static var null: Self { .init(time: nil) }
        
        public var emoji: String { "💧" }
        public var title: String? = "水風呂"
        public var unit: String { "秒" }
        
        public var time: TimeInterval?
        
        public init(time: TimeInterval?) {
            self.time = time
        }
    }
    
    public struct Relaxation: SaunaSetItemProtocol {
        static var null: Self { .init(time: nil) }
        
        public var emoji: String { "🍃" }
        public var title: String? = "休憩"
        public var unit: String { "分" }
        
        private var _time: TimeInterval?
        public var time: TimeInterval? {
            get {
                _time.map { $0 / 60 }
            }
            set {
                _time = newValue.map { $0 * 60 }
            }
        }
        
        public init(time: TimeInterval?) {
            self.time = time
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
        .init(
            sauna: .init(time: 5 * 60),
            coolBath: .init(time: 30),
            relaxation: .init(time: 10 * 60)
        )
    }
}
#endif
