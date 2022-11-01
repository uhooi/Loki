import Foundation

public struct SaunaSet {
    public var sauna: Sauna
    public var coolBath: CoolBath
    public var relaxation: Relaxation
    
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

#if DEBUG
extension SaunaSet {
    public static let preview: Self = .init(
        sauna: .init(time: 8 * 60),
        coolBath: .init(time: 30),
        relaxation: .init(
            time: 10 * 60,
            place: .outdoorAirBath,
            way: "インフィニティチェア"
        )
    )
}
#endif
