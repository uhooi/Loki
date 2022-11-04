import Foundation

public struct SaunaSet {
    public var sauna: Sauna
    public var coolBath: CoolBath
    public var relaxation: Relaxation
    
    public init(sauna: Sauna, coolBath: CoolBath, relaxation: Relaxation) {
        self.sauna = sauna
        self.coolBath = coolBath
        self.relaxation = relaxation
    }
    
    public struct Sauna {
        public var time: TimeInterval?
        
        public init(time: TimeInterval?) {
            self.time = time
        }
    }
    
    public struct CoolBath {
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
        
        public var time: TimeInterval?
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

// For save UserDefaults
extension SaunaSet: Codable {}
extension SaunaSet.Sauna: Codable {}
extension SaunaSet.CoolBath: Codable {}
extension SaunaSet.Relaxation: Codable {}
extension SaunaSet.Relaxation.RelaxationPlace: Codable {}

#if DEBUG
extension SaunaSet {
    public static let preview: Self = .init(
        sauna: .init(time: 5 * 60),
        coolBath: .init(time: 30),
        relaxation: .init(
            time: 10 * 60,
            place: .outdoorAirBath,
            way: "インフィニティチェア"
        )
    )
}
#endif
