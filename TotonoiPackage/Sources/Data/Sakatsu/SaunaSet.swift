import Foundation
import UserDefaultsCore

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
    
    public struct Sauna {
        static var null: Self { .init(time: nil) }
        
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
    
    public struct CoolBath {
        static var null: Self { .init(time: nil) }
        
        public var time: TimeInterval?
        
        public init(time: TimeInterval?) {
            self.time = time
        }
    }
    
    public struct Relaxation {
        public enum RelaxationPlace {
            case outdoorAirBath
            case indoorAirBath
            case other
        }
        
        static var null: Self { .init(time: nil, place: nil, way: nil) }
        
        private var _time: TimeInterval?
        public var time: TimeInterval? {
            get {
                _time.map { $0 / 60 }
            }
            set {
                _time = newValue.map { $0 * 60 }
            }
        }
        public var place: RelaxationPlace?
        public var way: String?
        
        public init(time: TimeInterval?, place: RelaxationPlace?, way: String?) {
            self.time = time
            self.place = place
            self.way = way
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
extension SaunaSet.Relaxation.RelaxationPlace: UserDefaultsPersistable {}

#if DEBUG
extension SaunaSet {
    public static var preview: Self {
        .init(
            sauna: .init(time: 5 * 60),
            coolBath: .init(time: 30),
            relaxation: .init(
                time: 10 * 60,
                place: .outdoorAirBath,
                way: "インフィニティチェア"
            )
        )
    }
}
#endif
