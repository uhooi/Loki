import Foundation
import SakatsuData

// MARK: UI state

struct SakatsuSettingsUiState {
    var defaultSaunaSet: SaunaSet = .init()
    var sakatsuSettingsError: SakatsuSettingsError?
}

// MARK: - Error

enum SakatsuSettingsError: LocalizedError {
    case defaultSaunaSetFetchFailed(localizedDescription: String)
    case defaultSaunaSetSaveFailed(localizedDescription: String)

    var errorDescription: String? {
        switch self {
        case let .defaultSaunaSetFetchFailed(localizedDescription):
            return localizedDescription
        case let .defaultSaunaSetSaveFailed(localizedDescription):
            return localizedDescription
        }
    }
}

// MARK: - View model

@MainActor
final class SakatsuSettingsViewModel<
    Repository: DefaultSaunaSetRepository,
    Validator: SakatsuValidatorProtocol
>: ObservableObject {
    @Published private(set) var uiState: SakatsuSettingsUiState

    private let repository: Repository
    private let validator: Validator

    init(
        repository: Repository = DefaultSaunaSetUserDefaultsClient.shared,
        validator: Validator = SakatsuValidator()
    ) {
        self.uiState = SakatsuSettingsUiState()
        self.repository = repository
        self.validator = validator
        refreshDefaultSaunaSet()
    }

    private func refreshDefaultSaunaSet() {
        do {
            uiState.defaultSaunaSet = try repository.defaultSaunaSet()
        } catch {
            uiState.sakatsuSettingsError = .defaultSaunaSetFetchFailed(localizedDescription: error.localizedDescription)
        }
    }

    private func saveDefaultSaunaSet() {
        do {
            try repository.saveDefaultSaunaSet(uiState.defaultSaunaSet)
        } catch {
            uiState.sakatsuSettingsError = .defaultSaunaSetSaveFailed(localizedDescription: error.localizedDescription)
        }
    }
}

// MARK: - Event handler

extension SakatsuSettingsViewModel {
    func onDefaultSaunaTimeChange(defaultSaunaTime: TimeInterval?) {
        guard validator.validate(saunaTime: defaultSaunaTime) else {
            return
        }
        uiState.defaultSaunaSet.sauna.time = defaultSaunaTime
        saveDefaultSaunaSet()
    }

    func onDefaultCoolBathTimeChange(defaultCoolBathTime: TimeInterval?) {
        guard validator.validate(coolBathTime: defaultCoolBathTime) else {
            return
        }
        uiState.defaultSaunaSet.coolBath.time = defaultCoolBathTime
        saveDefaultSaunaSet()
    }

    func onDefaultRelaxationTimeChange(defaultRelaxationTime: TimeInterval?) {
        guard validator.validate(relaxationTime: defaultRelaxationTime) else {
            return
        }
        uiState.defaultSaunaSet.relaxation.time = defaultRelaxationTime
        saveDefaultSaunaSet()
    }

    func onErrorAlertDismiss() {
        uiState.sakatsuSettingsError = nil
    }
}
