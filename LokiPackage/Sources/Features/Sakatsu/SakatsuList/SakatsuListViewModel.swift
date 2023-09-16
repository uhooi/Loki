import Foundation
import SakatsuData
import LogCore

// MARK: UI state

struct SakatsuListUiState {
    var sakatsus: [Sakatsu] = []
    var selectedSakatsu: Sakatsu?
    var sakatsuText: String?
    var shouldShowInputScreen = false
    var sakatsuListError: SakatsuListError?
}

// MARK: - Action

enum SakatsuListAction {
    case onAddButtonClick
    case onEditButtonClick(sakatsuIndex: Int)
    case onCopySakatsuTextButtonClick(sakatsuIndex: Int)
    case onSakatsuSave
    case onInputScreenCancelButtonClick
    case onInputScreenDismiss
    case onCopyingSakatsuTextAlertDismiss
    case onDelete(offsets: IndexSet)
    case onErrorAlertDismiss
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
final class SakatsuListViewModel: ObservableObject {
    @Published private(set) var uiState: SakatsuListUiState

    private let repository: any SakatsuRepository

    init(repository: some SakatsuRepository = DefaultSakatsuRepository.shared) {
        self.uiState = SakatsuListUiState()
        self.repository = repository
        refreshSakatsus()
    }

    func send(_ action: SakatsuListAction) {
        let message = "\(#file) \(#function) action: \(action)"
        Logger.standard.debug("\(message, privacy: .public)")
        switch action {
        case .onAddButtonClick:
            uiState.selectedSakatsu = nil
            uiState.shouldShowInputScreen = true
            
        case let .onEditButtonClick(sakatsuIndex: sakatsuIndex):
            uiState.selectedSakatsu = uiState.sakatsus[sakatsuIndex]
            uiState.shouldShowInputScreen = true
            
        case let .onCopySakatsuTextButtonClick(sakatsuIndex: sakatsuIndex):
            uiState.sakatsuText = sakatsuText(sakatsu: uiState.sakatsus[sakatsuIndex])

        case .onSakatsuSave:
            uiState.shouldShowInputScreen = false
            refreshSakatsus()

        case .onInputScreenCancelButtonClick:
            uiState.shouldShowInputScreen = false

        case .onInputScreenDismiss:
            uiState.shouldShowInputScreen = false
            uiState.selectedSakatsu = nil
            
        case .onCopyingSakatsuTextAlertDismiss:
            uiState.sakatsuText = nil
            
        case let .onDelete(offsets: offsets):
            let oldValue = uiState.sakatsus
            uiState.sakatsus.remove(atOffsets: offsets)
            do {
                try repository.saveSakatsus(uiState.sakatsus)
            } catch {
                uiState.sakatsuListError = .sakatsuDeleteFailed(localizedDescription: error.localizedDescription)
                uiState.sakatsus = oldValue
            }
            
        case .onErrorAlertDismiss:
            uiState.sakatsuListError = nil
        }
    }
}

// MARK: - Privates

private extension SakatsuListViewModel {
    func refreshSakatsus() {
        do {
            uiState.sakatsus = try repository.sakatsus()
        } catch {
            uiState.sakatsuListError = .sakatsuFetchFailed(localizedDescription: error.localizedDescription)
        }
    }

    func sakatsuText(sakatsu: Sakatsu) -> String {
        var text = ""

        if let foreword = sakatsu.foreword {
            text += "\(foreword)\n\n"
        }

        text += L10n.iDidLldSetS(sakatsu.saunaSets.count)
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

    func saunaSetItemText(saunaSetItem: any SaunaSetItemProtocol) -> String? {
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
