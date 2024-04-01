import Foundation
import SakatsuData
import LogCore

// MARK: UI state

struct SakatsuInputUiState {
    let editMode: SakatsuEditMode

    var sakatsu: Sakatsu = .init(saunaSets: [])
    var sakatsuInputError: SakatsuInputError?
}

enum SakatsuEditMode {
    case new
    case edit(sakatsu: Sakatsu)
}

// MARK: - Actions

enum SakatsuInputAction {
    case screen(_ action: SakatsuInputScreenAction)
    case view(_ action: SakatsuInputViewAction)
}

enum SakatsuInputAsyncAction {
    case screen(_ asyncAction: SakatsuInputScreenAsyncAction)
    case view(_ asyncAction: SakatsuInputViewAsyncAction)
}

// MARK: - Error

enum SakatsuInputError: LocalizedError {
    case saunaSetRemoveFailed
    case sakatsuSaveFailed

    var errorDescription: String? {
        switch self {
        case .saunaSetRemoveFailed: .init(localized: "Failed to delete set.", bundle: .module)
        case .sakatsuSaveFailed: .init(localized: "Failed to save Sakatsu.", bundle: .module)
        }
    }

    var failureReason: String? {
        switch self {
        case .saunaSetRemoveFailed, .sakatsuSaveFailed: .init(localized: "Detailed cause unknown.", bundle: .module)
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .saunaSetRemoveFailed, .sakatsuSaveFailed: .init(localized: "Please try again after some time.", bundle: .module)
        }
    }
}

// MARK: - View model

@MainActor
final class SakatsuInputViewModel: ObservableObject {
    @Published private(set) var uiState: SakatsuInputUiState

    private let onSakatsuSave: () -> Void
    private let onCancelButtonClick: () -> Void
    private let sakatsuRepository: any SakatsuRepository
    private let validator: any SakatsuValidator

    init(
        sakatsuEditMode: SakatsuEditMode,
        onSakatsuSave: @escaping () -> Void,
        onCancelButtonClick: @escaping () -> Void,
        sakatsuRepository: some SakatsuRepository = DefaultSakatsuRepository.shared,
        validator: some SakatsuValidator = DefaultSakatsuValidator()
    ) {
        self.uiState = .init(editMode: sakatsuEditMode)
        self.onSakatsuSave = onSakatsuSave
        self.onCancelButtonClick = onCancelButtonClick
        self.sakatsuRepository = sakatsuRepository
        self.validator = validator
    }

    func send(_ action: SakatsuInputAction) { // swiftlint:disable:this cyclomatic_complexity function_body_length
        let message = "\(#function) action: \(action)"
        Logger.standard.debug("\(message, privacy: .public)")

        switch action {
        case let .screen(screenAction):
            switch screenAction {
            case .onSaveButtonClick:
                Task {
                    do {
                        var sakatsus = (try? await sakatsuRepository.sakatsus()) ?? []
                        if let index = sakatsus.firstIndex(of: uiState.sakatsu) {
                            sakatsus[index] = uiState.sakatsu
                        } else {
                            sakatsus.append(uiState.sakatsu)
                        }
                        try await sakatsuRepository.saveSakatsus(sakatsus.sorted(by: { $0.visitingDate > $1.visitingDate }))
                    } catch {
                        uiState.sakatsuInputError = .sakatsuSaveFailed
                    }
                    onSakatsuSave()
                }

            case .onErrorAlertDismiss:
                uiState.sakatsuInputError = nil

            case .onCancelButtonClick:
                onCancelButtonClick()
            }

        case let .view(viewAction):
            switch viewAction {

            case .onAddNewSaunaSetButtonClick:
                Task {
                    uiState.sakatsu.saunaSets.append(await sakatsuRepository.makeDefaultSaunaSet())
                }

            case let .onFacilityNameChange(facilityName):
                guard validator.validate(facilityName: facilityName) else {
                    return
                }
                uiState.sakatsu.facilityName = facilityName

            case let .onVisitingDateChange(visitingDate):
                guard validator.validate(visitingDate: visitingDate) else {
                    return
                }
                uiState.sakatsu.visitingDate = visitingDate

            case let .onForewordChange(foreword):
                guard validator.validate(foreword: foreword) else {
                    return
                }
                uiState.sakatsu.foreword = foreword

            case let .onSaunaTitleChange(saunaSetIndex: saunaSetIndex, saunaTitle):
                guard validator.validate(saunaTitle: saunaTitle) else {
                    return
                }
                uiState.sakatsu.saunaSets[saunaSetIndex].sauna.title = saunaTitle

            case let .onSaunaTimeChange(saunaSetIndex: saunaSetIndex, saunaTime):
                guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                      validator.validate(saunaTime: saunaTime) else {
                    return
                }
                uiState.sakatsu.saunaSets[saunaSetIndex].sauna.time = saunaTime

            case let .onCoolBathTitleChange(saunaSetIndex: saunaSetIndex, coolBathTitle):
                guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                      validator.validate(coolBathTitle: coolBathTitle) else {
                    return
                }
                uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.title = coolBathTitle

            case let .onCoolBathTimeChange(saunaSetIndex: saunaSetIndex, coolBathTime):
                guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                      validator.validate(coolBathTime: coolBathTime) else {
                    return
                }
                uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.time = coolBathTime

            case let .onRelaxationTitleChange(saunaSetIndex: saunaSetIndex, relaxationTitle):
                guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                      validator.validate(relaxationTitle: relaxationTitle) else {
                    return
                }
                uiState.sakatsu.saunaSets[saunaSetIndex].relaxation.title = relaxationTitle

            case let .onRelaxationTimeChange(saunaSetIndex: saunaSetIndex, relaxationTime):
                guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                      validator.validate(relaxationTime: relaxationTime) else {
                    return
                }
                uiState.sakatsu.saunaSets[saunaSetIndex].relaxation.time = relaxationTime

            case let .onRemoveSaunaSetButtonClick(saunaSetIndex: saunaSetIndex):
                guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex) else {
                    uiState.sakatsuInputError = .saunaSetRemoveFailed
                    return
                }
                uiState.sakatsu.saunaSets.remove(at: saunaSetIndex)

            case let .onAfterwordChange(afterword):
                guard validator.validate(afterword: afterword) else {
                    return
                }
                uiState.sakatsu.afterword = afterword

            case let .onTemperatureTitleChange(temperatureIndex: temperatureIndex, temperatureTitle):
                guard uiState.sakatsu.saunaTemperatures.indices.contains(temperatureIndex),
                      validator.validate(temperatureTitle: temperatureTitle) else {
                    return
                }
                uiState.sakatsu.saunaTemperatures[temperatureIndex].title = temperatureTitle

            case let .onTemperatureChange(temperatureIndex: temperatureIndex, temperature):
                guard uiState.sakatsu.saunaTemperatures.indices.contains(temperatureIndex),
                      validator.validate(temperature: temperature) else {
                    return
                }
                uiState.sakatsu.saunaTemperatures[temperatureIndex].temperature = temperature

            case let .onTemperatureDelete(offsets):
                uiState.sakatsu.saunaTemperatures.remove(atOffsets: offsets)

            case .onAddNewTemperatureButtonClick:
                uiState.sakatsu.saunaTemperatures.insert(.sauna, at: max(uiState.sakatsu.saunaTemperatures.count, 1) - 1)
            }
        }
    }

    func sendAsync(_ asyncAction: SakatsuInputAsyncAction) async {
        let message = "\(#function) asyncAction: \(asyncAction)"
        Logger.standard.debug("\(message, privacy: .public)")

        switch asyncAction {
        case let .screen(screenAsyncAction):
            switch screenAsyncAction {
            case .task:
                switch uiState.editMode {
                case .new:
                    let defaultSaunaSet = await sakatsuRepository.makeDefaultSaunaSet()
                    uiState.sakatsu = Sakatsu(saunaSets: [defaultSaunaSet])
                case let .edit(sakatsu: sakatsu):
                    uiState.sakatsu = sakatsu
                }
            }

        case let .view(viewAsyncAction):
            switch viewAsyncAction {
            }
        }
    }
}
