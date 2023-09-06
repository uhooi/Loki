import SwiftUI
import UICore

struct SakatsuInputScreen: View {
    @StateObject private var viewModel: SakatsuInputViewModel

    private let onSakatsuSave: () -> Void

    @Environment(\.dismiss) private var dismiss

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
        .navigationTitle(L10n.registerSakatsu)
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
        .sakatsuInputScreenToolbar(
            saveButtonDisabled: viewModel.uiState.sakatsu.facilityName.isEmpty,
            onSaveButtonClick: {
                viewModel.send(.onSaveButtonClick)
                onSakatsuSave()
            }, onCloseButtonClick: { dismiss() }
        )
        .errorAlert(
            error: viewModel.uiState.sakatsuInputError,
            onDismiss: { viewModel.send(.onErrorAlertDismiss) }
        )
    }

    @MainActor
    init(
        editMode: EditMode,
        onSakatsuSave: @escaping () -> Void
    ) {
        self._viewModel = StateObject(wrappedValue: SakatsuInputViewModel(editMode: editMode))
        self.onSakatsuSave = onSakatsuSave
    }
}

// MARK: - Privates

private extension View {
    func sakatsuInputScreenToolbar(
        saveButtonDisabled: Bool,
        onSaveButtonClick: @escaping () -> Void,
        onCloseButtonClick: @escaping () -> Void
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(L10n.save) {
                    onSaveButtonClick()
                }
                .disabled(saveButtonDisabled)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    onCloseButtonClick()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        SakatsuInputScreen(
            editMode: .edit(sakatsu: .preview),
            onSakatsuSave: {}
        )
    }
}
