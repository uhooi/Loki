import SwiftUI
import UICore
import SakatsuData

struct SakatsuInputScreen: View {
    @StateObject private var viewModel: SakatsuInputViewModel<DefaultSaunaSetUserDefaultsClient, SakatsuUserDefaultsClient, SakatsuValidator>

    private let onSakatsuSave: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            SakatsuInputView(
                sakatsu: viewModel.uiState.sakatsu,
                onAddNewSaunaSetButtonClick: {
                    viewModel.onAddNewSaunaSetButtonClick()
                }, onFacilityNameChange: { facilityName in
                    viewModel.onFacilityNameChange(facilityName: facilityName)
                }, onVisitingDateChange: { visitingDate in
                    viewModel.onVisitingDateChange(visitingDate: visitingDate)
                }, onForewordChange: { foreword in
                    viewModel.onForewordChange(foreword: foreword)
                }, onSaunaTitleChange: { saunaSetIndex, saunaTitle in
                    viewModel.onSaunaTitleChange(saunaSetIndex: saunaSetIndex, saunaTitle: saunaTitle)
                }, onSaunaTimeChange: { saunaSetIndex, saunaTime in
                    viewModel.onSaunaTimeChange(saunaSetIndex: saunaSetIndex, saunaTime: saunaTime)
                }, onCoolBathTitleChange: { saunaSetIndex, coolBathTitle in
                    viewModel.onCoolBathTitleChange(saunaSetIndex: saunaSetIndex, coolBathTitle: coolBathTitle)
                }, onCoolBathTimeChange: { saunaSetIndex, coolBathTime in
                    viewModel.onCoolBathTimeChange(saunaSetIndex: saunaSetIndex, coolBathTime: coolBathTime)
                }, onRelaxationTitleChange: { saunaSetIndex, relaxationTitle in
                    viewModel.onRelaxationTitleChange(saunaSetIndex: saunaSetIndex, relaxationTitle: relaxationTitle)
                }, onRelaxationTimeChange: { saunaSetIndex, relaxationTime in
                    viewModel.onRelaxationTimeChange(saunaSetIndex: saunaSetIndex, relaxationTime: relaxationTime)
                }, onRemoveSaunaSetButtonClick: { saunaSetIndex in
                    viewModel.onRemoveSaunaSetButtonClick(saunaSetIndex: saunaSetIndex)
                }, onAfterwordChange: { afterword in
                    viewModel.onAfterwordChange(afterword: afterword)
                }, onTemperatureTitleChange: { temperatureIndex, temperatureTitle in
                    viewModel.onTemperatureTitleChange(temperatureIndex: temperatureIndex, temperatureTitle: temperatureTitle)
                }, onTemperatureChange: { temperatureIndex, temperature in
                    viewModel.onTemperatureChange(temperatureIndex: temperatureIndex, temperature: temperature)
                }, onTemperatureDelete: { offsets in
                    viewModel.onTemperatureDelete(at: offsets)
                }, onAddNewTemperatureButtonClick: {
                    viewModel.onAddNewTemperatureButtonClick()
                }
            )
            .navigationTitle(String(localized: "Register Sakatsu", bundle: .module))
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
            .sakatsuInputScreenToolbar(
                saveButtonDisabled: viewModel.uiState.sakatsu.facilityName.isEmpty,
                onSaveButtonClick: {
                    viewModel.onSaveButtonClick()
                    onSakatsuSave()
                }, onCloseButtonClick: { dismiss() }
            )
            .errorAlert(
                error: viewModel.uiState.sakatsuInputError,
                onDismiss: { viewModel.onErrorAlertDismiss() }
            )
        }
    }

    init(
        editMode: EditMode,
        onSakatsuSave: @escaping () -> Void
    ) {
        self._viewModel = StateObject(wrappedValue: SakatsuInputViewModel(editMode: editMode))
        self.onSakatsuSave = onSakatsuSave
    }
}

private extension View {
    func sakatsuInputScreenToolbar(
        saveButtonDisabled: Bool,
        onSaveButtonClick: @escaping () -> Void,
        onCloseButtonClick: @escaping () -> Void
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(String(localized: "Save", bundle: .module)) {
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

#if DEBUG
struct SakatsuInputScreen_Previews: PreviewProvider {
    static var previews: some View {
        SakatsuInputScreen(
            editMode: .edit(sakatsu: .preview),
            onSakatsuSave: {}
        )
    }
}
#endif
