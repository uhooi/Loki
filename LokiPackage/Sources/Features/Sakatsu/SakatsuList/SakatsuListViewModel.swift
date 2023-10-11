import Foundation
import SakatsuData
import LogCore

// MARK: UI state

struct SakatsuListUiState {
    var sakatsus: [Sakatsu] = []
    var selectedSakatsu: Sakatsu?
    var sakatsuText: String?
    var searchText: String = ""
    var shouldShowInputScreen = false
    var sakatsuListError: SakatsuListError?

    var filteredSakatsus: [Sakatsu] {
        sakatsus.filter {
            searchText.isEmpty
                || $0.visitingDate.formatted(date: .numeric, time: .omitted).contains(searchText)
                || $0.facilityName.contains(searchText)
                || $0.foreword?.contains(searchText) == true
                || $0.saunaSets.contains { saunaSet in
                    saunaSet.sauna.time?.formatted().contains(searchText) == true
                        || saunaSet.coolBath.time?.formatted().contains(searchText) == true
                        || saunaSet.relaxation.time?.formatted().contains(searchText) == true
                }
                || $0.afterword?.contains(searchText) == true
                || $0.saunaTemperatures.contains { temperature in
                    temperature.temperature?.formatted().contains(searchText) == true
                }
        }
    }
}

// MARK: - Action

enum SakatsuListAction {
    case onAddButtonClick
    case onSearchTextChange(searchText: String)
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
        case let .sakatsuFetchFailed(localizedDescription): localizedDescription
        case let .sakatsuDeleteFailed(localizedDescription): localizedDescription
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

    func send(_ action: SakatsuListAction) { // swiftlint:disable:this cyclomatic_complexity
        let message = "\(#file) \(#function) action: \(action)"
        Logger.standard.debug("\(message, privacy: .public)")
        switch action {
        case .onAddButtonClick:
            uiState.selectedSakatsu = nil
            uiState.shouldShowInputScreen = true

        case let .onSearchTextChange(searchText: searchText):
            uiState.searchText = searchText

        case let .onEditButtonClick(sakatsuIndex: sakatsuIndex):
            uiState.selectedSakatsu = uiState.filteredSakatsus[sakatsuIndex]
            uiState.shouldShowInputScreen = true

        case let .onCopySakatsuTextButtonClick(sakatsuIndex: sakatsuIndex):
            uiState.sakatsuText = sakatsuText(sakatsu: uiState.filteredSakatsus[sakatsuIndex])

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
            for index in offsets {
                let sakatsu = uiState.filteredSakatsus[index]
                if let firstIndex = uiState.sakatsus.firstIndex(of: sakatsu) {
                    uiState.sakatsus.remove(at: firstIndex)
                }
            }
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
