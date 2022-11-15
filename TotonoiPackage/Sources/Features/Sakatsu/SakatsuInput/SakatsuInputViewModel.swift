import Foundation
import Combine
import SakatsuData

struct SakatsuInputUiState {
    var isLoading: Bool
    var sakatsu: Sakatsu
    var savingSakatsuError: SavingSakatsuError?
}

enum SavingSakatsuError: LocalizedError {
    case sakatsuSaveFailed
    
    var errorDescription: String? {
        switch self {
        case .sakatsuSaveFailed:
            return "サ活の保存に失敗しました。"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .sakatsuSaveFailed:
            return "詳しい原因はわかりません。"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .sakatsuSaveFailed:
            return "時間をおいて再度お試しください。"
        }
    }
}

@MainActor
final class SakatsuInputViewModel<Repository: SakatsuRepository>: ObservableObject {
    @Published private(set) var uiState = SakatsuInputUiState(
        isLoading: true,
        sakatsu: .default,
        savingSakatsuError: nil
    )
    
    private let repository: Repository
    
    nonisolated init(repository: Repository = SakatsuUserDefaultsClient.shared) {
        self.repository = repository
    }
}

// MARK: - Event handler

extension SakatsuInputViewModel {
    func onSaveButtonClick() {
        do {
            var sakatsus = (try? repository.sakatsus()) ?? []
            sakatsus.append(uiState.sakatsu)
            try repository.saveSakatsus(sakatsus)
        } catch {
            uiState.savingSakatsuError = .sakatsuSaveFailed
        }
    }
    
    func onSavingErrorAlertDismiss() {
        uiState.savingSakatsuError = nil
    }
    
    func onAddNewSaunaSetButtonClick() {
        uiState.sakatsu.saunaSets.append(.null)
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
    
    func onSaunaTitleChange(saunaSetIndex: Int, saunaTitle: String?) {
        guard validate(saunaTitle: saunaTitle) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].sauna.title = saunaTitle
    }
    
    func onSaunaTimeChange(saunaSetIndex: Int, saunaTime: TimeInterval?) {
        guard let saunaTime, validate(saunaTime: saunaTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].sauna.time = saunaTime
    }
    
    func onCoolBathTitleChange(saunaSetIndex: Int, coolBathTitle: String?) {
        guard validate(coolBathTitle: coolBathTitle) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.title = coolBathTitle
    }
    
    func onCoolBathTimeChange(saunaSetIndex: Int, coolBathTime: TimeInterval?) {
        guard let coolBathTime, validate(coolBathTime: coolBathTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].coolBath.time = coolBathTime
    }
    
    func onRelaxationTitleChange(saunaSetIndex: Int, relaxationTitle: String?) {
        guard validate(relaxationTitle: relaxationTitle) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].relaxation.title = relaxationTitle
    }
    
    func onRelaxationTimeChange(saunaSetIndex: Int, relaxationTime: TimeInterval?) {
        guard let relaxationTime, validate(relaxationTime: relaxationTime) else {
            return
        }
        uiState.sakatsu.saunaSets[saunaSetIndex].relaxation.time = relaxationTime
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
    
    private func validate(saunaTime: TimeInterval) -> Bool {
        saunaTime >= 0
    }
    
    private func validate(coolBathTitle: String?) -> Bool {
        true
    }
    
    private func validate(coolBathTime: TimeInterval) -> Bool {
        coolBathTime >= 0
    }
    
    private func validate(relaxationTitle: String?) -> Bool {
        true
    }
    
    private func validate(relaxationTime: TimeInterval) -> Bool {
        relaxationTime >= 0
    }
    
    private func validate(afterword: String?) -> Bool {
        true
    }
}
