import Combine
import RecordsData

struct RecordListUiState {
    var isLoading: Bool
    let sakatsus: [Sakatsu]
}

@MainActor
final class RecordListViewModel: ObservableObject {
    @Published private(set) var uiState = RecordListUiState(isLoading: true, sakatsus: [])
    
    init() {
        refreshSakatsus()
    }
    
    private func refreshSakatsus() {
        uiState = RecordListUiState(isLoading: true, sakatsus: [])
        uiState = RecordListUiState(isLoading: false, sakatsus: [Sakatsu.preview]) // TODO: Fetch data
    }
}
