import Foundation
import SakatsuData
import LogCore

// MARK: UI state

struct SettingsUiState {
    var defaultSaunaTimes: DefaultSaunaTimes = .init()
    var settingsError: SettingsError?
}

// MARK: - Actions

enum SettingsAction {
    case screen(_ action: SettingsScreenAction)
    case view(_ action: SettingsViewAction)
}

enum SettingsAsyncAction {
    case screen(_ asyncAction: SettingsScreenAsyncAction)
    case view(_ asyncAction: SettingsViewAsyncAction)
}

// MARK: - Error

enum SettingsError: LocalizedError {
    case defaultSaunaSetFetchFailed(localizedDescription: String)
    case defaultSaunaSetSaveFailed(localizedDescription: String)

    var errorDescription: String? {
        switch self {
        case let .defaultSaunaSetFetchFailed(localizedDescription): localizedDescription
        case let .defaultSaunaSetSaveFailed(localizedDescription): localizedDescription
        }
    }
}

// MARK: - View model

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published private(set) var uiState: SettingsUiState

    private let onLicensesButtonClick: () -> Void
    private let repository: any SaunaTimeSettingsRepository
    private let validator: any SakatsuValidator

    init(
        onLicensesButtonClick: @escaping () -> Void,
        repository: some SaunaTimeSettingsRepository = DefaultSaunaTimeSettingsRepository.shared,
        validator: some SakatsuValidator = DefaultSakatsuValidator()
    ) {
        self.uiState = SettingsUiState()
        self.onLicensesButtonClick = onLicensesButtonClick
        self.repository = repository
        self.validator = validator
    }

    func send(_ action: SettingsAction) {
        let message = "\(#function) action: \(action)"
        Logger.standard.debug("\(message, privacy: .public)")

        switch action {
        case let .screen(screenAction):
            switch screenAction {
            case .onErrorAlertDismiss:
                uiState.settingsError = nil
            }

        case let .view(viewAction):
            switch viewAction {
            case let .onDefaultSaunaTimeChange(defaultSaunaTime: defaultSaunaTime):
                guard validator.validate(saunaTime: defaultSaunaTime) else {
                    return
                }
                uiState.defaultSaunaTimes.saunaTime = defaultSaunaTime
                Task {
                    await saveDefaultSaunaSet()
                }

            case let .onDefaultCoolBathTimeChange(defaultCoolBathTime: defaultCoolBathTime):
                guard validator.validate(coolBathTime: defaultCoolBathTime) else {
                    return
                }
                uiState.defaultSaunaTimes.coolBathTime = defaultCoolBathTime
                Task {
                    await saveDefaultSaunaSet()
                }

            case let .onDefaultRelaxationTimeChange(defaultRelaxationTime: defaultRelaxationTime):
                guard validator.validate(relaxationTime: defaultRelaxationTime) else {
                    return
                }
                uiState.defaultSaunaTimes.relaxationTime = defaultRelaxationTime
                Task {
                    await saveDefaultSaunaSet()
                }

            case .onLicensesButtonClick:
                onLicensesButtonClick()
            }
        }
    }

    func sendAsync(_ asyncAction: SettingsAsyncAction) async {
        let message = "\(#function) asyncAction: \(asyncAction)"
        Logger.standard.debug("\(message, privacy: .public)")

        switch asyncAction {
        case let .screen(screenAsyncAction):
            switch screenAsyncAction {
            case .task:
                await refreshDefaultSaunaTimes()
            }

        case let .view(viewAsyncAction):
            switch viewAsyncAction {
            }
        }
    }
}

// MARK: - Privates

private extension SettingsViewModel {
    func refreshDefaultSaunaTimes() async {
        do {
            uiState.defaultSaunaTimes = try await repository.defaultSaunaTimes()
        } catch is CancellationError {
            // Do nothing when cancelled
        } catch {
            uiState.settingsError = .defaultSaunaSetFetchFailed(localizedDescription: error.localizedDescription)
        }
    }

    func saveDefaultSaunaSet() async {
        do {
            try await repository.saveDefaultSaunaTimes(uiState.defaultSaunaTimes)
        } catch {
            uiState.settingsError = .defaultSaunaSetSaveFailed(localizedDescription: error.localizedDescription)
        }
    }
}
