import Combine
import RecordsData

struct RecordInputUiState {
    var isLoading: Bool
}

@MainActor
final class RecordInputViewModel: ObservableObject {
    @Published private(set) var uiState = RecordInputUiState(isLoading: true)
    
    init() {
    }
}
