import Foundation
import SakatsuData

// MARK: UI state

struct SakatsuInputUiState {
    var sakatsu: Sakatsu
    var sakatsuInputError: SakatsuInputError?
}

enum EditMode {
    case new
    case edit(sakatsu: Sakatsu)
}

// MARK: - Action

enum SakatsuInputAction {
    case onSaveButtonClick
    case onErrorAlertDismiss
    case onAddNewSaunaSetButtonClick
    case onFacilityNameChange(facilityName: String)
    case onVisitingDateChange(visitingDate: Date)
    case onForewordChange(foreword: String?)
    case onSaunaTitleChange(saunaSetIndex: Int, saunaTitle: String)
    case onSaunaTimeChange(saunaSetIndex: Int, saunaTime: TimeInterval?)
    case onCoolBathTitleChange(saunaSetIndex: Int, coolBathTitle: String)
    case onCoolBathTimeChange(saunaSetIndex: Int, coolBathTime: TimeInterval?)
    case onRelaxationTitleChange(saunaSetIndex: Int, relaxationTitle: String)
    case onRelaxationTimeChange(saunaSetIndex: Int, relaxationTime: TimeInterval?)
    case onRemoveSaunaSetButtonClick(saunaSetIndex: Int)
    case onAfterwordChange(afterword: String?)
    case onTemperatureTitleChange(temperatureIndex: Int, temperatureTitle: String)
    case onTemperatureChange(temperatureIndex: Int, temperature: Decimal?)
    case onTemperatureDelete(offsets: IndexSet)
    case onAddNewTemperatureButtonClick
}

// MARK: - Error

enum SakatsuInputError: LocalizedError {
    case saunaSetRemoveFailed
    case sakatsuSaveFailed

    var errorDescription: String? {
        switch self {
        case .saunaSetRemoveFailed:
            return L10n.failedToDeleteSet
        case .sakatsuSaveFailed:
            return L10n.failedToSaveSakatsu
        }
    }

    var failureReason: String? {
        switch self {
        case .saunaSetRemoveFailed, .sakatsuSaveFailed:
            return L10n.detailedCauseUnknown
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .saunaSetRemoveFailed, .sakatsuSaveFailed:
            return L10n.pleaseTryAgainAfterSomeTime
        }
    }
}

// MARK: - View model

@MainActor
final class SakatsuInputViewModel: ObservableObject {
    @Published private(set) var uiState: SakatsuInputUiState

    private let sakatsuRepository: any SakatsuRepository
    private let validator: any SakatsuValidatorProtocol

    init(
        editMode: EditMode,
        sakatsuRepository: some SakatsuRepository = DefaultSakatsuRepository.shared,
        validator: some SakatsuValidatorProtocol = SakatsuValidator()
    ) {
        switch editMode {
        case .new:
            let defaultSaunaSet = sakatsuRepository.makeDefaultSaunaSet()
            self.uiState = SakatsuInputUiState(sakatsu: .init(saunaSets: [defaultSaunaSet]))
        case let .edit(sakatsu: sakatsu):
            self.uiState = SakatsuInputUiState(sakatsu: sakatsu)
        }
        self.sakatsuRepository = sakatsuRepository
        self.validator = validator
    }
    
    func send(_ action: SakatsuInputAction) {
        switch action {
        case .onSaveButtonClick:
            do {
                var sakatsus = (try? sakatsuRepository.sakatsus()) ?? []
                if let index = sakatsus.firstIndex(of: uiState.sakatsu) {
                    sakatsus[index] = uiState.sakatsu
                } else {
                    sakatsus.append(uiState.sakatsu)
                }
                try sakatsuRepository.saveSakatsus(sakatsus.sorted(by: { $0.visitingDate > $1.visitingDate }))
            } catch {
                uiState.sakatsuInputError = .sakatsuSaveFailed
            }

        case .onErrorAlertDismiss:
            uiState.sakatsuInputError = nil

        case .onAddNewSaunaSetButtonClick:
            uiState.sakatsu.saunaSets.append(sakatsuRepository.makeDefaultSaunaSet())

        case .onFacilityNameChange(facilityName: let facilityName):
            guard validator.validate(facilityName: facilityName) else {
                return
            }
            uiState.sakatsu.facilityName = facilityName

        case .onVisitingDateChange(visitingDate: let visitingDate):
            guard validator.validate(visitingDate: visitingDate) else {
                return
            }
            uiState.sakatsu.visitingDate = visitingDate

        case .onForewordChange(foreword: let foreword):
            guard validator.validate(foreword: foreword) else {
                return
            }
            uiState.sakatsu.foreword = foreword

        case .onSaunaTitleChange(saunaSetIndex: let saunaSetIndex, saunaTitle: let saunaTitle):
            guard validator.validate(saunaTitle: saunaTitle) else {
                return
            }
            uiState.sakatsu.saunaSets[saunaSetIndex].sauna.title = saunaTitle

        case .onSaunaTimeChange(saunaSetIndex: let saunaSetIndex, saunaTime: let saunaTime):
            guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                  validator.validate(saunaTime: saunaTime) else {
                return
            }
            uiState.sakatsu.saunaSets[saunaSetIndex].sauna.time = saunaTime

        case .onCoolBathTitleChange(saunaSetIndex: let saunaSetIndex, coolBathTitle: let coolBathTitle):
            guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                  validator.validate(coolBathTitle: coolBathTitle) else {
                return
            }
            uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.title = coolBathTitle

        case .onCoolBathTimeChange(saunaSetIndex: let saunaSetIndex, coolBathTime: let coolBathTime):
            guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                  validator.validate(coolBathTime: coolBathTime) else {
                return
            }
            uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.time = coolBathTime

        case .onRelaxationTitleChange(saunaSetIndex: let saunaSetIndex, relaxationTitle: let relaxationTitle):
            guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                  validator.validate(relaxationTitle: relaxationTitle) else {
                return
            }
            uiState.sakatsu.saunaSets[saunaSetIndex].relaxation.title = relaxationTitle

        case .onRelaxationTimeChange(saunaSetIndex: let saunaSetIndex, relaxationTime: let relaxationTime):
            guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                  validator.validate(relaxationTime: relaxationTime) else {
                return
            }
            uiState.sakatsu.saunaSets[saunaSetIndex].relaxation.time = relaxationTime

        case .onRemoveSaunaSetButtonClick(saunaSetIndex: let saunaSetIndex):
            guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex) else {
                uiState.sakatsuInputError = .saunaSetRemoveFailed
                return
            }
            uiState.sakatsu.saunaSets.remove(at: saunaSetIndex)

        case .onAfterwordChange(afterword: let afterword):
            guard validator.validate(afterword: afterword) else {
                return
            }
            uiState.sakatsu.afterword = afterword

        case .onTemperatureTitleChange(temperatureIndex: let temperatureIndex, temperatureTitle: let temperatureTitle):
            guard uiState.sakatsu.saunaTemperatures.indices.contains(temperatureIndex),
                  validator.validate(temperatureTitle: temperatureTitle) else {
                return
            }
            uiState.sakatsu.saunaTemperatures[temperatureIndex].title = temperatureTitle

        case .onTemperatureChange(temperatureIndex: let temperatureIndex, temperature: let temperature):
            guard uiState.sakatsu.saunaTemperatures.indices.contains(temperatureIndex),
                  validator.validate(temperature: temperature) else {
                return
            }
            uiState.sakatsu.saunaTemperatures[temperatureIndex].temperature = temperature

        case .onTemperatureDelete(offsets: let offsets):
            uiState.sakatsu.saunaTemperatures.remove(atOffsets: offsets)

        case .onAddNewTemperatureButtonClick:
            uiState.sakatsu.saunaTemperatures.insert(.sauna, at: max(uiState.sakatsu.saunaTemperatures.count, 1) - 1)
        }
    }
}
