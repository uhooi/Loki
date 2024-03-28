import Foundation
import SakatsuData
import LogCore

// MARK: UI state

struct SettingsUiState: Sendable {
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

    nonisolated
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
    nonisolated
    func refreshDefaultSaunaTimes() async {
        do {
            #if DEBUG
            try await Task.sleep(for: .seconds(3))
            #endif
            let defaultSaunaTimes = try repository.defaultSaunaTimes()
            Task { @MainActor in
                uiState.defaultSaunaTimes = defaultSaunaTimes
            }
        } catch is CancellationError {
            return
        } catch {
            Task { @MainActor in
                uiState.settingsError = .defaultSaunaSetFetchFailed(localizedDescription: error.localizedDescription)
            }
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
