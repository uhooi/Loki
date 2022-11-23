import SwiftUI
import Algorithms
import SakatsuData

struct SakatsuInputView: View {
    let sakatsu: Sakatsu
    
    let onAddNewSaunaSetButtonClick: (() -> Void)
    let onFacilityNameChange: ((String) -> Void)
    let onVisitingDateChange: ((Date) -> Void)
    let onForewordChange: ((String?) -> Void)
    let onSaunaTitleChange: ((Int, String) -> Void)
    let onSaunaTimeChange: ((Int, TimeInterval?) -> Void)
    let onCoolBathTitleChange: ((Int, String) -> Void)
    let onCoolBathTimeChange: ((Int, TimeInterval?) -> Void)
    let onRelaxationTitleChange: ((Int, String) -> Void)
    let onRelaxationTimeChange: ((Int, TimeInterval?) -> Void)
    let onRemoveSaunaSetButtonClick: ((Int) -> Void)
    let onAfterwordChange: ((String?) -> Void)
    let onTemperatureTitleChange: (Int, String) -> Void
    let onTemperatureChange: (Int, Decimal?) -> Void
    
    var body: some View {
        Form {
            generalSection
            forewordSection
            saunaSetSections
            newSaunaSetSection
            afterwordSection
            temperaturesSection
        }
    }
    
    private var generalSection: some View {
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
    }
    
    private var forewordSection: some View {
        Section {
            TextField("オプション", text: .init(get: {
                sakatsu.foreword ?? ""
            }, set: { newValue in
                onForewordChange(newValue)
            }))
        } header: {
            Text("まえがき")
        }
    }
    
    private var saunaSetSections: some View {
        ForEach(sakatsu.saunaSets.indexed(), id: \.index) { saunaSetIndex, saunaSet in
            Section {
                saunaSetItemTimeInputView(
                    saunaSetIndex: saunaSetIndex,
                    saunaSetItem: saunaSet.sauna,
                    onTitleChange: onSaunaTitleChange,
                    onTimeChange: onSaunaTimeChange
                )
                saunaSetItemTimeInputView(
                    saunaSetIndex: saunaSetIndex,
                    saunaSetItem: saunaSet.coolBath,
                    onTitleChange: onCoolBathTitleChange,
                    onTimeChange: onCoolBathTimeChange
                )
                saunaSetItemTimeInputView(
                    saunaSetIndex: saunaSetIndex,
                    saunaSetItem: saunaSet.relaxation,
                    onTitleChange: onRelaxationTitleChange,
                    onTimeChange: onRelaxationTimeChange
                )
            } header: {
                Text("\(saunaSetIndex + 1)セット目")
            } footer: {
                Button("セットを削除", role: .destructive) {
                    onRemoveSaunaSetButtonClick(saunaSetIndex)
                }
                .font(.footnote)
            }
        }
    }
    
    private var newSaunaSetSection: some View {
        Section {
            Button("新しいセットを追加", action: onAddNewSaunaSetButtonClick)
        }
    }
    
    private var afterwordSection: some View {
        Section {
            TextField("オプション", text: .init(get: {
                sakatsu.afterword ?? ""
            }, set: { newValue in
                onAfterwordChange(newValue)
            }))
        } header: {
            Text("あとがき")
        }
    }
    
    private var temperaturesSection: some View {
        Section {
            ForEach(sakatsu.saunaTemperatures.indexed(), id: \.index) { saunaTemperatureIndex, saunaTemperature in
                saunaTemperatureInputView(
                    saunaTemperatureIndex: saunaTemperatureIndex,
                    saunaTemperature: saunaTemperature,
                    onTitleChange: onTemperatureTitleChange,
                    onTemperatureChange: onTemperatureChange
                )
            }
        } header: {
            Text("温度")
        }
    }
    
    private func saunaSetItemTimeInputView(
        saunaSetIndex: Int,
        saunaSetItem: any SaunaSetItemProtocol,
        onTitleChange: @escaping (Int, String) -> Void,
        onTimeChange: @escaping (Int, TimeInterval?) -> Void
    ) -> some View {
        HStack {
            HStack(spacing: 0) {
                Text("\(saunaSetItem.emoji)")
                TextField("オプション", text: .init(get: {
                    saunaSetItem.title
                }, set: { newValue in
                    onTitleChange(saunaSetIndex, newValue)
                }))
            }
            TextField("オプション", value: .init(get: {
                saunaSetItem.time
            }, set: { newValue in
                onTimeChange(saunaSetIndex, newValue)
            }), format: .number)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            Text(saunaSetItem.unit)
        }
    }
    
    private func saunaTemperatureInputView(
        saunaTemperatureIndex: Int,
        saunaTemperature: SaunaTemperature,
        onTitleChange: @escaping (Int, String) -> Void,
        onTemperatureChange: @escaping (Int, Decimal?) -> Void
    ) -> some View {
        HStack {
            HStack(spacing: 0) {
                Text("\(saunaTemperature.emoji)")
                TextField("オプション", text: .init(get: {
                    saunaTemperature.title
                }, set: { newValue in
                    onTitleChange(saunaTemperatureIndex, newValue)
                }))
            }
            TextField("オプション", value: .init(get: {
                saunaTemperature.temperature
            }, set: { newValue in
                onTemperatureChange(saunaTemperatureIndex, newValue)
            }), format: .number)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            Text("℃")
        }
    }
}

#if DEBUG
struct SakatsuInputView_Previews: PreviewProvider {
    static var previews: some View {
        SakatsuInputView(
            sakatsu: .preview,
            onAddNewSaunaSetButtonClick: {},
            onFacilityNameChange: { _ in },
            onVisitingDateChange: { _ in },
            onForewordChange: { _ in },
            onSaunaTitleChange: { _, _ in },
            onSaunaTimeChange: { _, _ in },
            onCoolBathTitleChange: { _, _ in },
            onCoolBathTimeChange: {_, _ in },
            onRelaxationTitleChange: { _, _ in },
            onRelaxationTimeChange: { _, _ in },
            onRemoveSaunaSetButtonClick: { _ in },
            onAfterwordChange: { _ in },
            onTemperatureTitleChange: { _, _ in },
            onTemperatureChange: { _, _ in }
        )
    }
}
#endif
