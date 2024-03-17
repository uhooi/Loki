import Foundation
import SakatsuData
import LogCore

// MARK: UI state

struct SettingsUiState {
    var defaultSaunaTimes: DefaultSaunaTimes = .init()
    var settingsError: SettingsError?
}

// MARK: - Action

enum SettingsAction {
    case screen(_ action: SettingsScreenAction)
    case view(_ action: SettingsViewAction)
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
    #if DEBUG
    private let onDebugButtonClick: () -> Void
    #endif
    private let repository: any SaunaTimeSettingsRepository
    private let validator: any SakatsuValidator

    init(
        onLicensesButtonClick: @escaping () -> Void,
        onDebugButtonClick: @escaping () -> Void,
        repository: some SaunaTimeSettingsRepository = DefaultSaunaTimeSettingsRepository.shared,
        validator: some SakatsuValidator = DefaultSakatsuValidator()
    ) {
        self.uiState = SettingsUiState()
        self.onLicensesButtonClick = onLicensesButtonClick
        self.onDebugButtonClick = onDebugButtonClick
        self.repository = repository
        self.validator = validator

        refreshDefaultSaunaTimes()
    }

    func send(_ action: SettingsAction) { // swiftlint:disable:this cyclomatic_complexity
        let message = "\(#function) action: \(action)"
        Logger.standard.debug("\(message, privacy: .public)")

        switch action {
        case let .screen(screenAction):
            switch screenAction {
            case .onErrorAlertDismiss:
                uiState.settingsError = nil

            #if DEBUG
            case .onDebugButtonClick:
                onDebugButtonClick()
            #endif
            }

        case let .view(viewAction):
            switch viewAction {
            case let .onDefaultSaunaTimeChange(defaultSaunaTime: defaultSaunaTime):
                guard validator.validate(saunaTime: defaultSaunaTime) else {
                    return
                }
                uiState.defaultSaunaTimes.saunaTime = defaultSaunaTime
                saveDefaultSaunaSet()

            case let .onDefaultCoolBathTimeChange(defaultCoolBathTime: defaultCoolBathTime):
                guard validator.validate(coolBathTime: defaultCoolBathTime) else {
                    return
                }
                uiState.defaultSaunaTimes.coolBathTime = defaultCoolBathTime
                saveDefaultSaunaSet()

            case let .onDefaultRelaxationTimeChange(defaultRelaxationTime: defaultRelaxationTime):
                guard validator.validate(relaxationTime: defaultRelaxationTime) else {
                    return
                }
                uiState.defaultSaunaTimes.relaxationTime = defaultRelaxationTime
                saveDefaultSaunaSet()

            case .onLicensesButtonClick:
                onLicensesButtonClick()
            }
        }
    }
}

// MARK: - Privates

private extension SettingsViewModel {
    func refreshDefaultSaunaTimes() {
        do {
            uiState.defaultSaunaTimes = try repository.defaultSaunaTimes()
        } catch {
            uiState.settingsError = .defaultSaunaSetFetchFailed(localizedDescription: error.localizedDescription)
        }
    }

    func saveDefaultSaunaSet() {
        do {
            try repository.saveDefaultSaunaTimes(uiState.defaultSaunaTimes)
        } catch {
            uiState.settingsError = .defaultSaunaSetSaveFailed(localizedDescription: error.localizedDescription)
        }
    }
}
