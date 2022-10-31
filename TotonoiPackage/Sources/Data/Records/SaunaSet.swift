import Foundation

public struct SaunaSet {
    public let sauna: Sauna
    public let coolBath: CoolBath
    public let relaxation: Relaxation
    
    public struct Sauna {
        public let time: TimeInterval?
        
        public init(time: TimeInterval?) {
            self.time = time
        }
    }
    
    public struct CoolBath {
        public let time: TimeInterval?
        
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
        
        public let time: TimeInterval?
        public let place: RelaxationPlace?
        public let way: String?
        
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
