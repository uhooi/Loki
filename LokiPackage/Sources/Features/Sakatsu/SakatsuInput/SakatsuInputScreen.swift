import SwiftUI
import LogCore
import UICore

struct SakatsuInputScreen: View {
    @StateObject private var viewModel: SakatsuInputViewModel

    private let onSakatsuSave: () -> Void
    private let onCancelButtonClick: () -> Void

    var body: some View {
        SakatsuInputView(
            sakatsu: viewModel.uiState.sakatsu,
            onAddNewSaunaSetButtonClick: {
                viewModel.send(.onAddNewSaunaSetButtonClick)
            }, onFacilityNameChange: { facilityName in
                viewModel.send(.onFacilityNameChange(facilityName: facilityName))
            }, onVisitingDateChange: { visitingDate in
                viewModel.send(.onVisitingDateChange(visitingDate: visitingDate))
            }, onForewordChange: { foreword in
                viewModel.send(.onForewordChange(foreword: foreword))
            }, onSaunaTitleChange: { saunaSetIndex, saunaTitle in
                viewModel.send(.onSaunaTitleChange(saunaSetIndex: saunaSetIndex, saunaTitle: saunaTitle))
            }, onSaunaTimeChange: { saunaSetIndex, saunaTime in
                viewModel.send(.onSaunaTimeChange(saunaSetIndex: saunaSetIndex, saunaTime: saunaTime))
            }, onCoolBathTitleChange: { saunaSetIndex, coolBathTitle in
                viewModel.send(.onCoolBathTitleChange(saunaSetIndex: saunaSetIndex, coolBathTitle: coolBathTitle))
            }, onCoolBathTimeChange: { saunaSetIndex, coolBathTime in
                viewModel.send(.onCoolBathTimeChange(saunaSetIndex: saunaSetIndex, coolBathTime: coolBathTime))
            }, onRelaxationTitleChange: { saunaSetIndex, relaxationTitle in
                viewModel.send(.onRelaxationTitleChange(saunaSetIndex: saunaSetIndex, relaxationTitle: relaxationTitle))
            }, onRelaxationTimeChange: { saunaSetIndex, relaxationTime in
                viewModel.send(.onRelaxationTimeChange(saunaSetIndex: saunaSetIndex, relaxationTime: relaxationTime))
            }, onRemoveSaunaSetButtonClick: { saunaSetIndex in
                viewModel.send(.onRemoveSaunaSetButtonClick(saunaSetIndex: saunaSetIndex))
            }, onAfterwordChange: { afterword in
                viewModel.send(.onAfterwordChange(afterword: afterword))
            }, onTemperatureTitleChange: { temperatureIndex, temperatureTitle in
                viewModel.send(.onTemperatureTitleChange(temperatureIndex: temperatureIndex, temperatureTitle: temperatureTitle))
            }, onTemperatureChange: { temperatureIndex, temperature in
                viewModel.send(.onTemperatureChange(temperatureIndex: temperatureIndex, temperature: temperature))
            }, onTemperatureDelete: { offsets in
                viewModel.send(.onTemperatureDelete(offsets: offsets))
            }, onAddNewTemperatureButtonClick: {
                viewModel.send(.onAddNewTemperatureButtonClick)
            }
        )
        .navigationTitle(String(localized: "Register Sakatsu", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
        .sakatsuInputScreenToolbar(
            saveButtonDisabled: viewModel.uiState.sakatsu.facilityName.isEmpty,
            onSaveButtonClick: {
                viewModel.send(.onSaveButtonClick)
                onSakatsuSave()
            }, onCancelButtonClick: { onCancelButtonClick() }
        )
        .errorAlert(
            error: viewModel.uiState.sakatsuInputError,
            onDismiss: { viewModel.send(.onErrorAlertDismiss) }
        )
    }

    @MainActor
    init(
        sakatsuEditMode: SakatsuEditMode,
        onSakatsuSave: @escaping () -> Void,
        onCancelButtonClick: @escaping () -> Void
    ) {
        let message = "\(#file) \(#function)"
        Logger.standard.debug("\(message, privacy: .public)")
        self._viewModel = StateObject(wrappedValue: SakatsuInputViewModel(sakatsuEditMode: sakatsuEditMode))
        self.onSakatsuSave = onSakatsuSave
        self.onCancelButtonClick = onCancelButtonClick
    }
}

// MARK: - Privates

private extension View {
    func sakatsuInputScreenToolbar(
        saveButtonDisabled: Bool,
        onSaveButtonClick: @escaping () -> Void,
        onCancelButtonClick: @escaping () -> Void
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "Save", bundle: .module), action: onSaveButtonClick)
                    .disabled(saveButtonDisabled)
            }
            ToolbarItem(placement: .topBarLeading) {
                Button(String(localized: "Cancel", bundle: .module), role: .cancel, action: onCancelButtonClick)
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview {
    NavigationStack {
        SakatsuInputScreen(
            sakatsuEditMode: .edit(sakatsu: .preview),
            onSakatsuSave: {},
            onCancelButtonClick: {}
        )
    }
}
#endif
