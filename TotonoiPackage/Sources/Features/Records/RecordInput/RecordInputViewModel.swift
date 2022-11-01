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
    
    func onSubmitFacilityName(facilityName: String) {
        guard validate(facilityName: facilityName) else {
            return
        }
        uiState.sakatsu.facilityName = facilityName
    }
    
    func onSubmitVisitingDate(visitingDate: Date) {
        guard validate(visitingDate: visitingDate) else {
            return
        }
        uiState.sakatsu.visitingDate = visitingDate
    }
    
    func onSubmitSaunaTime(saunaTime: TimeInterval?) {
        guard validate(saunaTime: saunaTime) else {
            return
        }
//        uiState.sakatsu.saunaSets.first?.sauna.time = saunaTime // TODO:
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
}
