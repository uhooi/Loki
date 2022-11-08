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
    
    nonisolated init(repository: Repository = SakatsuUserDefaultsClient.shared) {
        self.repository = repository
        Task {
            await refreshSakatsus()
        }
    }
    
    private func refreshSakatsus() async {
        uiState.isLoading = true
        uiState.sakatsus = (try? await repository.sakatsus()) ?? [] // FIXME:
        uiState.isLoading = false
    }
}

// MARK: Event handler

extension SakatsuListViewModel {
    func onSakatsuSave() async {
        await refreshSakatsus()
    }
    
    func onEditButtonClick() {
        // TODO:
    }
    
    func onDelete(at offsets: IndexSet) async throws {
        uiState.sakatsus.remove(atOffsets: offsets)
        try await repository.saveSakatsus(uiState.sakatsus)
    }
}
