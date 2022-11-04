import Foundation
import Combine
import RecordsData

struct RecordInputUiState {
    var isLoading: Bool
    var sakatsu: Sakatsu
}

@MainActor
final class RecordInputViewModel: ObservableObject {
    private static let sakatsusKey = "sakatsus"
    
    @Published private(set) var uiState = RecordInputUiState(
        isLoading: true,
        sakatsu: .init(facilityName: "", visitingDate: .now, saunaSets: [.init(sauna: .init(time: nil), coolBath: .init(time: nil), relaxation: .init(time: nil, place: nil, way: nil))], comment: nil)
    )
    
    func onSaveButtonClick() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        var sakatsus: [Sakatsu]
        if let data = UserDefaults.standard.data(forKey: Self.sakatsusKey) {
            sakatsus = (try? jsonDecoder.decode([Sakatsu].self, from: data)) ?? []
        } else {
            sakatsus = []
        }
        sakatsus.append(uiState.sakatsu)
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(sakatsus) else {
            return
        }
        UserDefaults.standard.set(data, forKey: Self.sakatsusKey)
    }
    
    func onAddNewSaunaSetButtonClick() {
        uiState.sakatsu.saunaSets.append(.init(sauna: .init(time: nil), coolBath: .init(time: nil), relaxation: .init(time: nil, place: nil, way: nil)))
    }
    
    func onFacilityNameChange(facilityName: String) {
        guard validate(facilityName: facilityName) else {
            return
        }
        uiState.sakatsu.facilityName = facilityName
    }
    
    func onVisitingDateChange(visitingDate: Date) {
        guard validate(visitingDate: visitingDate) else {
            return
        }
        uiState.sakatsu.visitingDate = visitingDate
    }
    
    func onSaunaTimeChange(saunaSetIndex: Int, saunaTime: TimeInterval?) {
        guard let saunaTime, validate(saunaTime: saunaTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].sauna.time = saunaTime * 60
    }
    
    func onCoolBathTimeChange(saunaSetIndex: Int, coolBathTime: TimeInterval?) {
        guard let coolBathTime, validate(coolBathTime: coolBathTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.time = coolBathTime
    }
    
    func onRelaxationTimeChange(saunaSetIndex: Int, relaxationTime: TimeInterval?) {
        guard let relaxationTime, validate(relaxationTime: relaxationTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].relaxation.time = relaxationTime * 60
    }
   
    private func validate(facilityName: String) -> Bool {
        facilityName != ""
    }
    
    private func validate(visitingDate: Date) -> Bool {
        true // TODO: Disable future dates
    }
    
    private func validate(saunaTime: TimeInterval) -> Bool {
        saunaTime >= 0
    }
    
    private func validate(coolBathTime: TimeInterval) -> Bool {
        coolBathTime >= 0
    }
    
    private func validate(relaxationTime: TimeInterval) -> Bool {
        relaxationTime >= 0
    }
}
