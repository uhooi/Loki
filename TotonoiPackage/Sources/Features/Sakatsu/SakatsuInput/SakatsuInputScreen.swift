import Foundation
import SwiftUI
import Algorithms
import SakatsuData

struct SakatsuInputScreen: View {
    @StateObject private var viewModel = SakatsuInputViewModel()
    
    let onSakatsuSave: () -> Void
    
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
            }, onSaunaTimeChange: { saunaSetIndex, saunaTime in
                viewModel.onSaunaTimeChange(saunaSetIndex: saunaSetIndex, saunaTime: saunaTime)
            }, onCoolBathTimeChange: { saunaSetIndex, coolBathTime in
                viewModel.onCoolBathTimeChange(saunaSetIndex: saunaSetIndex, coolBathTime: coolBathTime)
            }, onRelaxationTimeChange: { saunaSetIndex, relaxationTime in
                viewModel.onRelaxationTimeChange(saunaSetIndex: saunaSetIndex, relaxationTime: relaxationTime)
            }, onAfterwordChange: { afterword in
                viewModel.onAfterwordChange(afterword: afterword)
            }
        )
        .navigationTitle("サ活登録")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("保存") {
                    viewModel.onSaveButtonClick()
                    onSakatsuSave()
                }
                .disabled(viewModel.uiState.sakatsu.facilityName.isEmpty)
            }
        }
        .alert(
            isPresented: .constant(viewModel.uiState.savingSakatsuError != nil),
            error: viewModel.uiState.savingSakatsuError
        ) { _ in
            Button("OK") {
                viewModel.onSavingErrorAlertDismiss()
            }
        } message: { savingSakatsuError in
            Text(savingSakatsuError.failureReason! + savingSakatsuError.recoverySuggestion!)
        }
    }
}

struct SakatsuInputScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SakatsuInputScreen(onSakatsuSave: {})
        }
    }
}

private struct SakatsuInputView: View {
    let sakatsu: Sakatsu
    
    let onAddNewSaunaSetButtonClick: (() -> Void)
    let onFacilityNameChange: ((String) -> Void)
    let onVisitingDateChange: ((Date) -> Void)
    let onForewordChange: ((String?) -> Void)
    let onSaunaTimeChange: ((Int, TimeInterval?) -> Void)
    let onCoolBathTimeChange: ((Int, TimeInterval?) -> Void)
    let onRelaxationTimeChange: ((Int, TimeInterval?) -> Void)
    let onAfterwordChange: ((String?) -> Void)
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("施設名")
                    TextField("必須", text: .init(get: {
                        sakatsu.facilityName
                    }, set: { newValue in
                        onFacilityNameChange(newValue)
                    }))
                }
                DatePicker(
                    "訪問日",
                    selection: .init(get: {
                        sakatsu.visitingDate
                    }, set: { newValue in
                        onVisitingDateChange(newValue)
                    }),
                    displayedComponents: [.date]
                )
            }
            Section(header: Text("まえがき")) {
                TextField("オプション", text: .init(get: {
                    sakatsu.foreword ?? ""
                }, set: { newValue in
                    onForewordChange(newValue)
                }))
            }
            ForEach(sakatsu.saunaSets.indexed(), id: \.index) { saunaSetIndex, saunaSet in
                Section(header: Text("\(saunaSetIndex + 1)セット目")) {
                    saunaSetItemInputView(
                        saunaSetIndex: saunaSetIndex,
                        saunaSetItem: saunaSet.sauna,
                        onTimeChange: onSaunaTimeChange
                    )
                    saunaSetItemInputView(
                        saunaSetIndex: saunaSetIndex,
                        saunaSetItem: saunaSet.coolBath,
                        onTimeChange: onCoolBathTimeChange
                    )
                    saunaSetItemInputView(
                        saunaSetIndex: saunaSetIndex,
                        saunaSetItem: saunaSet.relaxation,
                        onTimeChange: onRelaxationTimeChange
                    )
                }
            }
            Section {
                Button("新しいセットを追加", action: onAddNewSaunaSetButtonClick)
            }
            Section(header: Text("あとがき")) {
                TextField("オプション", text: .init(get: {
                    sakatsu.afterword ?? ""
                }, set: { newValue in
                    onAfterwordChange(newValue)
                }))
            }
        }
    }
    
    init(
        sakatsu: Sakatsu,
        onAddNewSaunaSetButtonClick: @escaping () -> Void,
        onFacilityNameChange: @escaping (String) -> Void,
        onVisitingDateChange: @escaping (Date) -> Void,
        onForewordChange: @escaping (String?) -> Void,
        onSaunaTimeChange: @escaping (Int, TimeInterval?) -> Void,
        onCoolBathTimeChange: @escaping (Int, TimeInterval?) -> Void,
        onRelaxationTimeChange: @escaping (Int, TimeInterval?) -> Void,
        onAfterwordChange: @escaping (String?) -> Void
    ) {
        self.sakatsu = sakatsu
        self.onAddNewSaunaSetButtonClick = onAddNewSaunaSetButtonClick
        self.onFacilityNameChange = onFacilityNameChange
        self.onVisitingDateChange = onVisitingDateChange
        self.onForewordChange = onForewordChange
        self.onSaunaTimeChange = onSaunaTimeChange
        self.onCoolBathTimeChange = onCoolBathTimeChange
        self.onRelaxationTimeChange = onRelaxationTimeChange
        self.onAfterwordChange = onAfterwordChange
    }
    
    private func saunaSetItemInputView(
        saunaSetIndex: Int,
        saunaSetItem: any SaunaSetItemProtocol,
        onTimeChange: @escaping (Int, TimeInterval?) -> Void
    ) -> some View {
        HStack {
            Text("\(saunaSetItem.emoji)\(saunaSetItem.title)")
            TextField("オプション", value: .init(get: {
                saunaSetItem.time
            }, set: { newValue in
                onTimeChange(saunaSetIndex, newValue)
            }), format: .number)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.trailing)
            Text(saunaSetItem.unit)
        }
    }
}

struct SakatsuInputView_Previews: PreviewProvider {
    static var previews: some View {
        SakatsuInputView(
            sakatsu: Sakatsu.preview,
            onAddNewSaunaSetButtonClick: {},
            onFacilityNameChange: { _ in },
            onVisitingDateChange: { _ in },
            onForewordChange: { _ in },
            onSaunaTimeChange: { _, _ in },
            onCoolBathTimeChange: {_, _ in },
            onRelaxationTimeChange: { _, _ in },
            onAfterwordChange: { _ in }
        )
    }
}
