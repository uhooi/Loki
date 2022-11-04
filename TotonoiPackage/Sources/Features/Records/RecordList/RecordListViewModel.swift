import Foundation
import Combine
import RecordsData

struct RecordListUiState {
    var isLoading: Bool
    var sakatsus: [Sakatsu]
}

@MainActor
final class RecordListViewModel: ObservableObject {
    private static let sakatsuKey = "sakatsu"
    
    @Published private(set) var uiState = RecordListUiState(isLoading: true, sakatsus: [])
    
    init() {
        refreshSakatsus()
    }
    
    private func refreshSakatsus() {
        uiState.isLoading = true
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data = UserDefaults.standard.data(forKey: Self.sakatsuKey),
           let sakatsu = try? jsonDecoder.decode(Sakatsu.self, from: data) {
            uiState.sakatsus = [sakatsu] // TODO: Fetch multi data
        }
        uiState.isLoading = false
    }
}
