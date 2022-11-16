import Foundation
import Combine
import SakatsuData

// MARK: UI state

struct SakatsuInputUiState {
    var sakatsu: Sakatsu
    var sakatsuInputError: SakatsuInputError? = nil
}

// MARK: - Error

enum SakatsuInputError: LocalizedError {
    case saunaSetRemoveFailed
    case sakatsuSaveFailed
    
    var errorDescription: String? {
        switch self {
        case .saunaSetRemoveFailed:
            return "セットの削除に失敗しました。"
        case .sakatsuSaveFailed:
            return "サ活の保存に失敗しました。"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .saunaSetRemoveFailed, .sakatsuSaveFailed:
            return "詳しい原因はわかりません。"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .saunaSetRemoveFailed, .sakatsuSaveFailed:
            return "時間をおいて再度お試しください。"
        }
    }
}

// MARK: - View model

@MainActor
final class SakatsuInputViewModel<Repository: SakatsuRepository>: ObservableObject {
    @Published private(set) var uiState: SakatsuInputUiState
    
    private let repository: Repository
    
    init(sakatsu: Sakatsu, repository: Repository = SakatsuUserDefaultsClient.shared) {
        self.uiState = SakatsuInputUiState(sakatsu: sakatsu)
        self.repository = repository
    }
}

// MARK: - Event handler

extension SakatsuInputViewModel {
    func onSaveButtonClick() {
        do {
            var sakatsus = (try? repository.sakatsus()) ?? []
            if let index = sakatsus.firstIndex(of: uiState.sakatsu) {
                sakatsus[index] = uiState.sakatsu
            } else {
                sakatsus.append(uiState.sakatsu)
            }
            try repository.saveSakatsus(sakatsus.sorted(by: { $0.visitingDate > $1.visitingDate }))
        } catch {
            uiState.sakatsuInputError = .sakatsuSaveFailed
        }
    }
    
    func onErrorAlertDismiss() {
        uiState.sakatsuInputError = nil
    }
    
    func onAddNewSaunaSetButtonClick() {
        uiState.sakatsu.saunaSets.append(.init())
    }
    
    func onFacilityNameChange(facilityName: String) {
        guard validate(facilityName: facilityName) else {
            return
        }
        uiState.sakatsu.facilityName = facilityName
    }
    
    func onVisitingDateChange(visitingDate: Date) {
        guard validate(visitingDate: visitingDate) else {
            return
        }
        uiState.sakatsu.visitingDate = visitingDate
    }
    
    func onForewordChange(foreword: String?) {
        guard validate(foreword: foreword) else {
            return
        }
        uiState.sakatsu.foreword = foreword
    }
    
    func onSaunaTitleChange(saunaSetIndex: Int, saunaTitle: String) {
        guard validate(saunaTitle: saunaTitle) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].sauna.title = saunaTitle
    }
    
    func onSaunaTimeChange(saunaSetIndex: Int, saunaTime: TimeInterval?) {
        guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
              validate(saunaTime: saunaTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].sauna.time = saunaTime
    }
    
    func onCoolBathTitleChange(saunaSetIndex: Int, coolBathTitle: String) {
        guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
              validate(coolBathTitle: coolBathTitle) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.title = coolBathTitle
    }
    
    func onCoolBathTimeChange(saunaSetIndex: Int, coolBathTime: TimeInterval?) {
        guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
              validate(coolBathTime: coolBathTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.time = coolBathTime
    }
    
    func onRelaxationTitleChange(saunaSetIndex: Int, relaxationTitle: String) {
        guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
              validate(relaxationTitle: relaxationTitle) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].relaxation.title = relaxationTitle
    }
    
    func onRelaxationTimeChange(saunaSetIndex: Int, relaxationTime: TimeInterval?) {
        guard uiState.sakatsu.saunaSets.indices.contains(saunaSetIndex),
              validate(relaxationTime: relaxationTime) else {
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
        guard validate(afterword: afterword) else {
            return
        }
        uiState.sakatsu.afterword = afterword
    }
}

// MARK: - Validate

extension SakatsuInputViewModel {
    private func validate(facilityName: String) -> Bool {
        !facilityName.isEmpty
    }
    
    private func validate(visitingDate: Date) -> Bool {
        true // TODO: Disable future dates
    }
    
    private func validate(foreword: String?) -> Bool {
        true
    }
    
    private func validate(saunaTitle: String?) -> Bool {
        true
    }
    
    private func validate(saunaTime: TimeInterval?) -> Bool {
        if let saunaTime {
            return saunaTime >= 0
        } else {
            return true
        }
    }
    
    private func validate(coolBathTitle: String?) -> Bool {
        true
    }
    
    private func validate(coolBathTime: TimeInterval?) -> Bool {
        if let coolBathTime {
            return coolBathTime >= 0
        } else {
            return true
        }
    }
    
    private func validate(relaxationTitle: String?) -> Bool {
        true
    }
    
    private func validate(relaxationTime: TimeInterval?) -> Bool {
        if let relaxationTime {
            return relaxationTime >= 0
        } else {
            return true
        }
    }
    
    private func validate(afterword: String?) -> Bool {
        true
    }
}
