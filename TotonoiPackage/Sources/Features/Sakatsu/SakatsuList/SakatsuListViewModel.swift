import Foundation
import Combine
import SakatsuData

struct SakatsuListUiState {
    var isLoading: Bool
    var sakatsus: [Sakatsu]
}

@MainActor
final class SakatsuListViewModel<Repository: SakatsuRepository>: ObservableObject {
    @Published private(set) var uiState = SakatsuListUiState(
        isLoading: true,
        sakatsus: []
    )
    
    private let repository: Repository
    
    init(repository: Repository = SakatsuUserDefaultsClient.shared) {
        self.repository = repository
        refreshSakatsus()
    }
    
    private func refreshSakatsus() {
        uiState.isLoading = true
        uiState.sakatsus = (try? repository.sakatsus()) ?? [] // FIXME:
        uiState.isLoading = false
    }
}

// MARK: Event handler

extension SakatsuListViewModel {
    func onSakatsuSave() {
        refreshSakatsus()
    }
    
    func onEditButtonClick() {
        // TODO:
    }
    
    func onDelete(at offsets: IndexSet) throws {
        uiState.sakatsus.remove(atOffsets: offsets)
        try repository.saveSakatsus(uiState.sakatsus)
    }
}
