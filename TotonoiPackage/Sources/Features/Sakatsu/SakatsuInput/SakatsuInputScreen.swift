import SwiftUI
import SakatsuData

struct SakatsuInputScreen: View {
    @StateObject private var viewModel: SakatsuInputViewModel<SakatsuUserDefaultsClient>
    
    private let onSakatsuSave: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
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
            }
        )
        .navigationTitle("サ活登録")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    viewModel.onSaveButtonClick()
                    onSakatsuSave()
                }
                .disabled(viewModel.uiState.sakatsu.facilityName.isEmpty)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .alert(
            isPresented: .init(get: {
                viewModel.uiState.sakatsuInputError != nil
            }, set: { _ in
                viewModel.onErrorAlertDismiss()
            }),
            error: viewModel.uiState.sakatsuInputError
        ) { _ in
        } message: { sakatsuInputError in
            Text((sakatsuInputError.failureReason ?? "") + (sakatsuInputError.recoverySuggestion ?? ""))
        }
    }
    
    init(
        sakatsu: Sakatsu?,
        onSakatsuSave: @escaping () -> Void
    ) {
        self._viewModel = StateObject(wrappedValue: SakatsuInputViewModel(sakatsu: sakatsu ?? .init()))
        self.onSakatsuSave = onSakatsuSave
    }
}

struct SakatsuInputScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SakatsuInputScreen(
                sakatsu: .preview,
                onSakatsuSave: {}
            )
        }
    }
}
