import Foundation
import Combine
import SakatsuData

// MARK: UI state

struct SakatsuInputUiState {
    var sakatsu: Sakatsu
    var sakatsuInputError: SakatsuInputError? = nil
}

enum EditMode {
    case new
    case edit(sakatsu: Sakatsu)
}

// MARK: - Error

enum SakatsuInputError: LocalizedError {
    case saunaSetRemoveFailed
    case sakatsuSaveFailed
    
    var errorDescription: String? {
        switch self {
        case .saunaSetRemoveFailed:
            return String(localized: "Failed to delete set.", bundle: .module)
        case .sakatsuSaveFailed:
            return String(localized: "Failed to save Sakatsu.", bundle: .module)
        }
    }
    
    var failureReason: String? {
        switch self {
        case .saunaSetRemoveFailed, .sakatsuSaveFailed:
            return String(localized: "Detailed cause unknown.", bundle: .module)
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .saunaSetRemoveFailed, .sakatsuSaveFailed:
            return String(localized: "Please try again after some time.", bundle: .module)
        }
    }
}

// MARK: - View model

@MainActor
final class SakatsuInputViewModel<
    DRepository: DefaultSaunaSetRepository,
    SRepository: SakatsuRepository,
    Validator: SakatsuValidatorProtocol
>: ObservableObject {
    @Published private(set) var uiState: SakatsuInputUiState
    
    private let defaultSaunaSetRepository: DRepository
    private let sakatsuRepository: SRepository
    private let validator: Validator
    
    init(
        editMode: EditMode,
        defaultSaunaSetRepository: DRepository = DefaultSaunaSetUserDefaultsClient.shared,
        sakatsuRepository: SRepository = SakatsuUserDefaultsClient.shared,
        validator: Validator = SakatsuValidator()
    ) {
        switch editMode {
        case .new:
            let defaultSaunaSet: SaunaSet? = try? defaultSaunaSetRepository.defaultSaunaSet()
            self.uiState = SakatsuInputUiState(sakatsu: .init(saunaSets: [defaultSaunaSet ?? .init()]))
        case let .edit(sakatsu: sakatsu):
            self.uiState = SakatsuInputUiState(sakatsu: sakatsu)
        }
        self.defaultSaunaSetRepository = defaultSaunaSetRepository
        self.sakatsuRepository = sakatsuRepository
        self.validator = validator
    }
    
    private func defaultSaunaSet() -> SaunaSet {
        (try? defaultSaunaSetRepository.defaultSaunaSet()) ?? .init()
    }
}

// MARK: - Event handler

extension SakatsuInputViewModel {
    func onSaveButtonClick() {
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
    }
    
    func onErrorAlertDismiss() {
        uiState.sakatsuInputError = nil
    }
    
    func onAddNewSaunaSetButtonClick() {
        uiState.sakatsu.saunaSets.append(defaultSaunaSet())
    }
    
    func onFacilityNameChange(facilityName: String) {
        guard validator.validate(facilityName: facilityName) else {
            return
        }
        uiState.sakatsu.facilityName = facilityName
    }
    
    func onVisitingDateChange(visitingDate: Date) {
        guard validator.validate(visitingDate: visitingDate) else {
            return
        }
        uiState.sakatsu.visitingDate = visitingDate
    }
    
    func onForewordChange(foreword: String?) {
        guard validator.validate(foreword: foreword) else {
            return
        }
        uiState.sakatsu.foreword = foreword
    }
    
    func onSaunaTitleChange(saunaSetIndex: Int, saunaTitle: String) {
        guard validator.validate(saunaTitle: saunaTitle) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].sauna.title = saunaTitle
    }
    
    func onSaunaTimeChange(saunaSetIndex: Int, saunaTime: TimeInterval?) {
        guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
              validator.validate(saunaTime: saunaTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].sauna.time = saunaTime
    }
    
    func onCoolBathTitleChange(saunaSetIndex: Int, coolBathTitle: String) {
        guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
              validator.validate(coolBathTitle: coolBathTitle) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.title = coolBathTitle
    }
    
    func onCoolBathTimeChange(saunaSetIndex: Int, coolBathTime: TimeInterval?) {
        guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
              validator.validate(coolBathTime: coolBathTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.time = coolBathTime
    }
    
    func onRelaxationTitleChange(saunaSetIndex: Int, relaxationTitle: String) {
        guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
              validator.validate(relaxationTitle: relaxationTitle) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].relaxation.title = relaxationTitle
    }
    
    func onRelaxationTimeChange(saunaSetIndex: Int, relaxationTime: TimeInterval?) {
        guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
              validator.validate(relaxationTime: relaxationTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].relaxation.time = relaxationTime
    }
    
    func onRemoveSaunaSetButtonClick(saunaSetIndex: Int) {
        guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex) else {
            uiState.sakatsuInputError = .saunaSetRemoveFailed
            return
        }
        uiState.sakatsu.saunaSets.remove(at: saunaSetIndex)
    }
    
    func onAfterwordChange(afterword: String?) {
        guard validator.validate(afterword: afterword) else {
            return
        }
        uiState.sakatsu.afterword = afterword
    }
    
    func onTemperatureTitleChange(temperatureIndex: Int, temperatureTitle: String) {
        guard uiState.sakatsu.saunaTemperatures.indices.contains(temperatureIndex),
              validator.validate(temperatureTitle: temperatureTitle) else {
            return
        }
        uiState.sakatsu.saunaTemperatures[temperatureIndex].title = temperatureTitle
    }
    
    func onTemperatureChange(temperatureIndex: Int, temperature: Decimal?) {
        guard uiState.sakatsu.saunaTemperatures.indices.contains(temperatureIndex),
              validator.validate(temperature: temperature) else {
            return
        }
        uiState.sakatsu.saunaTemperatures[temperatureIndex].temperature = temperature
    }
    
    func onTemperatureDelete(at offsets: IndexSet) {
        uiState.sakatsu.saunaTemperatures.remove(atOffsets: offsets)
    }
    
    func onAddNewTemperatureButtonClick() {
        uiState.sakatsu.saunaTemperatures.insert(.sauna, at: max(uiState.sakatsu.saunaTemperatures.count, 1) - 1)
    }
}
