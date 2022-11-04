import Foundation
import Combine
import RecordsData

struct RecordListUiState {
    var isLoading: Bool
    var sakatsus: [Sakatsu]
}

@MainActor
final class RecordListViewModel: ObservableObject {
    private static let sakatsusKey = "sakatsus"
    
    @Published private(set) var uiState = RecordListUiState(isLoading: true, sakatsus: [])
    
    init() {
        refreshSakatsus()
    }
    
    func onSakatsuSave() {
        refreshSakatsus()
    }
    
    func onDelete(at offsets: IndexSet) {
        uiState.sakatsus.remove(atOffsets: offsets)
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(uiState.sakatsus) else {
            return
        }
        UserDefaults.standard.set(data, forKey: Self.sakatsusKey)
    }
    
    private func refreshSakatsus() {
        uiState.isLoading = true
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data = UserDefaults.standard.data(forKey: Self.sakatsusKey),
           let sakatsus = try? jsonDecoder.decode([Sakatsu].self, from: data) {
            uiState.sakatsus = sakatsus
        }
        uiState.isLoading = false
    }
}
