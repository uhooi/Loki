import Foundation
import SakatsuData
import LogCore

// MARK: UI state

struct SakatsuInputUiState {
    var sakatsu: Sakatsu
    var sakatsuInputError: SakatsuInputError?
}

enum SakatsuEditMode {
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

    private let sakatsuRepository: any SakatsuRepository
    private let validator: any SakatsuValidator

    init(
        sakatsuEditMode: SakatsuEditMode,
        sakatsuRepository: some SakatsuRepository = DefaultSakatsuRepository.shared,
        validator: some SakatsuValidator = DefaultSakatsuValidator()
    ) {
        switch sakatsuEditMode {
        case .new:
            let defaultSaunaSet = sakatsuRepository.makeDefaultSaunaSet()
            self.uiState = SakatsuInputUiState(sakatsu: .init(saunaSets: [defaultSaunaSet]))
        case let .edit(sakatsu: sakatsu):
            self.uiState = SakatsuInputUiState(sakatsu: sakatsu)
        }
        self.sakatsuRepository = sakatsuRepository
        self.validator = validator
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func send(_ action: SakatsuInputAction) {
        let message = "\(#file) \(#function) action: \(action)"
        Logger.standard.debug("\(message, privacy: .public)")
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

        case let .onFacilityNameChange(facilityName: facilityName):
            guard validator.validate(facilityName: facilityName) else {
                return
            }
            uiState.sakatsu.facilityName = facilityName

        case let .onVisitingDateChange(visitingDate: visitingDate):
            guard validator.validate(visitingDate: visitingDate) else {
                return
            }
            uiState.sakatsu.visitingDate = visitingDate

        case let .onForewordChange(foreword: foreword):
            guard validator.validate(foreword: foreword) else {
                return
            }
            uiState.sakatsu.foreword = foreword

        case let .onSaunaTitleChange(saunaSetIndex: saunaSetIndex, saunaTitle: saunaTitle):
            guard validator.validate(saunaTitle: saunaTitle) else {
                return
            }
            uiState.sakatsu.saunaSets[saunaSetIndex].sauna.title = saunaTitle

        case let .onSaunaTimeChange(saunaSetIndex: saunaSetIndex, saunaTime: saunaTime):
            guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                  validator.validate(saunaTime: saunaTime) else {
                return
            }
            uiState.sakatsu.saunaSets[saunaSetIndex].sauna.time = saunaTime

        case let .onCoolBathTitleChange(saunaSetIndex: saunaSetIndex, coolBathTitle: coolBathTitle):
            guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                  validator.validate(coolBathTitle: coolBathTitle) else {
                return
            }
            uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.title = coolBathTitle

        case let .onCoolBathTimeChange(saunaSetIndex: saunaSetIndex, coolBathTime: coolBathTime):
            guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                  validator.validate(coolBathTime: coolBathTime) else {
                return
            }
            uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.time = coolBathTime

        case let .onRelaxationTitleChange(saunaSetIndex: saunaSetIndex, relaxationTitle: relaxationTitle):
            guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
                  validator.validate(relaxationTitle: relaxationTitle) else {
                return
            }
            uiState.sakatsu.saunaSets[saunaSetIndex].relaxation.title = relaxationTitle

        case let .onRelaxationTimeChange(saunaSetIndex: saunaSetIndex, relaxationTime: relaxationTime):
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

        case let .onAfterwordChange(afterword: afterword):
            guard validator.validate(afterword: afterword) else {
                return
            }
            uiState.sakatsu.afterword = afterword

        case let .onTemperatureTitleChange(temperatureIndex: temperatureIndex, temperatureTitle: temperatureTitle):
            guard uiState.sakatsu.saunaTemperatures.indices.contains(temperatureIndex),
                  validator.validate(temperatureTitle: temperatureTitle) else {
                return
            }
            uiState.sakatsu.saunaTemperatures[temperatureIndex].title = temperatureTitle

        case let .onTemperatureChange(temperatureIndex: temperatureIndex, temperature: temperature):
            guard uiState.sakatsu.saunaTemperatures.indices.contains(temperatureIndex),
                  validator.validate(temperature: temperature) else {
                return
            }
            uiState.sakatsu.saunaTemperatures[temperatureIndex].temperature = temperature

        case let .onTemperatureDelete(offsets: offsets):
            uiState.sakatsu.saunaTemperatures.remove(atOffsets: offsets)

        case .onAddNewTemperatureButtonClick:
            uiState.sakatsu.saunaTemperatures.insert(.sauna, at: max(uiState.sakatsu.saunaTemperatures.count, 1) - 1)
        }
    }
}
