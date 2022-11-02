import Foundation
import Combine
import RecordsData

struct RecordInputUiState {
    var isLoading: Bool
    var sakatsu: Sakatsu
}

@MainActor
final class RecordInputViewModel: ObservableObject {
    @Published private(set) var uiState = RecordInputUiState(
        isLoading: true,
        sakatsu: Sakatsu.preview // TODO: Use real data
    )
    
    init() {
    }
    
    func didTapSaveButton() {
        // TODO:
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
    
    func onSaunaTimeChange(saunaTime: TimeInterval?) {
        guard validate(saunaTime: saunaTime) else {
            return
        }
//        uiState.sakatsu.saunaSets.first?.sauna.time = saunaTime * 60 // TODO:
    }
    
    func onCoolBathTimeChange(coolBathTime: TimeInterval?) {
        guard validate(coolBathTime: coolBathTime) else {
            return
        }
//        uiState.sakatsu.saunaSets.first?.coolBath.time = coolBathTime // TODO:
    }
    
    func onRelaxationTimeChange(relaxationTime: TimeInterval?) {
        guard validate(relaxationTime: relaxationTime) else {
            return
        }
//        uiState.sakatsu.saunaSets.first?.relaxation.time = relaxationTime * 60 // TODO:
    }
   
    private func validate(facilityName: String) -> Bool {
        return true // TODO: Validate
    }
    
    private func validate(visitingDate: Date) -> Bool {
        return true // TODO: Validate
    }
    
    private func validate(saunaTime: TimeInterval?) -> Bool {
        return true // TODO: Validate
    }
    
    private func validate(coolBathTime: TimeInterval?) -> Bool {
        return true // TODO: Validate
    }
    
    private func validate(relaxationTime: TimeInterval?) -> Bool {
        return true // TODO: Validate
    }
}
