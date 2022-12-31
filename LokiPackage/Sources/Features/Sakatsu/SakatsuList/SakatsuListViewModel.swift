import Foundation
import Combine
import SakatsuData

// MARK: UI state

struct SakatsuListUiState {
    var sakatsus: [Sakatsu] = []
    var selectedSakatsu: Sakatsu? = nil
    var sakatsuText: String? = nil
    var shouldShowInputSheet: Bool = false
    var shouldShowSettingsScreen: Bool = false
    var sakatsuListError: SakatsuListError? = nil
}

// MARK: - Error

enum SakatsuListError: LocalizedError {
    case sakatsuFetchFailed(localizedDescription: String)
    case sakatsuDeleteFailed(localizedDescription: String)
    
    var errorDescription: String? {
        switch self {
        case let .sakatsuFetchFailed(localizedDescription):
            return localizedDescription
        case let .sakatsuDeleteFailed(localizedDescription):
            return localizedDescription
        }
    }
}

// MARK: - View model

@MainActor
final class SakatsuListViewModel<Repository: SakatsuRepository>: ObservableObject {
    @Published private(set) var uiState: SakatsuListUiState
    
    private let repository: Repository
    
    init(repository: Repository = SakatsuUserDefaultsClient.shared) {
        self.uiState = SakatsuListUiState()
        self.repository = repository
        refreshSakatsus()
    }
    
    private func refreshSakatsus() {
        do {
            uiState.sakatsus = try repository.sakatsus()
        } catch {
            uiState.sakatsuListError = .sakatsuFetchFailed(localizedDescription: error.localizedDescription)
        }
    }
}

// MARK: - Event handler

extension SakatsuListViewModel {
    func onSakatsuSave() {
        uiState.shouldShowInputSheet = false
        refreshSakatsus()
    }
    
    func onAddButtonClick() {
        uiState.selectedSakatsu = nil
        uiState.shouldShowInputSheet = true
    }
    
    func onEditButtonClick(sakatsuIndex: Int) {
        uiState.selectedSakatsu = uiState.sakatsus[sakatsuIndex]
        uiState.shouldShowInputSheet = true
    }
    
    func onSettingsButtonClick() {
        uiState.shouldShowSettingsScreen = true
    }
    
    func onSettingsScreenDismiss() {
        uiState.shouldShowSettingsScreen = false
    }
    
    func onCopySakatsuTextButtonClick(sakatsuIndex: Int) {
        uiState.sakatsuText = sakatsuText(sakatsu: uiState.sakatsus[sakatsuIndex])
    }
    
    func onInputSheetDismiss() {
        uiState.shouldShowInputSheet = false
        uiState.selectedSakatsu = nil
    }
    
    func onCopyingSakatsuTextAlertDismiss() {
        uiState.sakatsuText = nil
    }
    
    func onDelete(at offsets: IndexSet) {
        let oldValue = uiState.sakatsus
        uiState.sakatsus.remove(atOffsets: offsets)
        do {
            try repository.saveSakatsus(uiState.sakatsus)
        } catch {
            uiState.sakatsuListError = .sakatsuDeleteFailed(localizedDescription: error.localizedDescription)
            uiState.sakatsus = oldValue
        }
    }
    
    func onErrorAlertDismiss() {
        uiState.sakatsuListError = nil
    }
    
    private func sakatsuText(sakatsu: Sakatsu) -> String {
        var text = ""
        
        if let foreword = sakatsu.foreword {
            text += "\(foreword)\n\n"
        }
        
        text += String(localized: "I did \(sakatsu.saunaSets.count) set(s).", bundle: .module)
        for saunaSet in sakatsu.saunaSets {
            var saunaSetItemTexts: [String] = []
            saunaSetItemText(saunaSetItem: saunaSet.sauna).map { saunaSetItemTexts.append($0) }
            saunaSetItemText(saunaSetItem: saunaSet.coolBath).map { saunaSetItemTexts.append($0) }
            saunaSetItemText(saunaSetItem: saunaSet.relaxation).map { saunaSetItemTexts.append($0) }
            
            if !saunaSetItemTexts.isEmpty {
                text += "\n"
                text += saunaSetItemTexts.joined(separator: "→")
            }
        }
        
        if let afterword = sakatsu.afterword {
            text += "\n\n\(afterword)"
        }
        
        return text
    }
    
    private func saunaSetItemText(saunaSetItem: any SaunaSetItemProtocol) -> String? {
        guard !(saunaSetItem.title.isEmpty && saunaSetItem.time == nil) else {
            return nil
        }
        
        var text = "\(saunaSetItem.emoji)\(saunaSetItem.title)"
        if let time = saunaSetItem.time {
            text += "（\(time.formatted())\(saunaSetItem.unit)）"
        }
        
        return text
    }
}
