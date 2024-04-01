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

// MARK: - Actions

enum SakatsuListAction {
    case screen(_ action: SakatsuListScreenAction)
    case view(_ action: SakatsuListViewAction)
}

enum SakatsuListAsyncAction {
    case screen(_ asyncAction: SakatsuListScreenAsyncAction)
    case view(_ asyncAction: SakatsuListViewAsyncAction)
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

    private let onSettingsButtonClick: () -> Void
    private let repository: any SakatsuRepository

    init(
        onSettingsButtonClick: @escaping () -> Void,
        repository: some SakatsuRepository = DefaultSakatsuRepository.shared
    ) {
        self.uiState = SakatsuListUiState()
        self.onSettingsButtonClick = onSettingsButtonClick
        self.repository = repository
    }

    func send(_ action: SakatsuListAction) { // swiftlint:disable:this cyclomatic_complexity function_body_length
        let message = "\(#function) action: \(action)"
        Logger.standard.debug("\(message, privacy: .public)")

        switch action {
        case let .screen(screenAction):
            switch screenAction {
            case .onAddButtonClick:
                uiState.selectedSakatsu = nil
                uiState.shouldShowInputScreen = true

            case let .onSearchTextChange(searchText: searchText):
                uiState.searchText = searchText

            case .onSakatsuSave:
                uiState.shouldShowInputScreen = false
                Task {
                    await refreshSakatsus()
                }

            case .onInputScreenCancelButtonClick:
                uiState.shouldShowInputScreen = false

            case .onInputScreenDismiss:
                uiState.shouldShowInputScreen = false
                uiState.selectedSakatsu = nil

            case .onCopyingSakatsuTextAlertDismiss:
                uiState.sakatsuText = nil

            case .onErrorAlertDismiss:
                uiState.sakatsuListError = nil

            case .onSettingsButtonClick:
                onSettingsButtonClick()
            }

        case let .view(viewAction):
            switch viewAction {
            case let .onEditButtonClick(sakatsuIndex: sakatsuIndex):
                uiState.selectedSakatsu = uiState.filteredSakatsus[sakatsuIndex]
                uiState.shouldShowInputScreen = true

            case let .onCopySakatsuTextButtonClick(sakatsuIndex: sakatsuIndex):
                uiState.sakatsuText = sakatsuText(sakatsu: uiState.filteredSakatsus[sakatsuIndex])

            case let .onDelete(offsets: offsets):
                let oldValue = uiState.sakatsus
                for index in offsets {
                    let sakatsu = uiState.filteredSakatsus[index]
                    if let firstIndex = uiState.sakatsus.firstIndex(of: sakatsu) {
                        uiState.sakatsus.remove(at: firstIndex)
                    }
                }
                Task {
                    do {
                        try await repository.saveSakatsus(uiState.sakatsus)
                    } catch {
                        uiState.sakatsuListError = .sakatsuDeleteFailed(localizedDescription: error.localizedDescription)
                        uiState.sakatsus = oldValue
                    }
                }
            }
        }
    }

    func sendAsync(_ asyncAction: SakatsuListAsyncAction) async {
        let message = "\(#function) asyncAction: \(asyncAction)"
        Logger.standard.debug("\(message, privacy: .public)")

        switch asyncAction {
        case let .screen(screenAsyncAction):
            switch screenAsyncAction {
            case .task:
                await refreshSakatsus()
            }

        case let .view(viewAsyncAction):
            switch viewAsyncAction {
            }
        }
    }
}

// MARK: - Privates

private extension SakatsuListViewModel {
    func refreshSakatsus() async {
        do {
            uiState.sakatsus = try await repository.sakatsus()
        } catch is CancellationError {
            // Do nothing when cancelled
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
