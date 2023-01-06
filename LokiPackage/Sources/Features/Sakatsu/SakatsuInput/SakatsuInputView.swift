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
    let onTemperatureDelete: (IndexSet) -> Void
    let onAddNewTemperatureButtonClick: (() -> Void)

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
                Text("Facility name", bundle: .module)
                TextField(String(localized: "Required", bundle: .module), text: .init(get: {
                    sakatsu.facilityName
                }, set: { newValue in
                    onFacilityNameChange(newValue)
                }))
            }
            DatePicker(
                String(localized: "Visiting date", bundle: .module),
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
            TextField(
                String(localized: "Optional", bundle: .module),
                text: .init(
                    get: {
                        sakatsu.foreword ?? ""
                    }, set: { newValue in
                        onForewordChange(newValue)
                    }
                ),
                axis: .vertical
            )
        } header: {
            Text("Foreword", bundle: .module)
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
                Text("Set \(saunaSetIndex + 1)", bundle: .module)
            } footer: {
                Button(String(localized: "Delete set", bundle: .module), role: .destructive) {
                    onRemoveSaunaSetButtonClick(saunaSetIndex)
                }
                .font(.footnote)
            }
        }
    }

    private var newSaunaSetSection: some View {
        Section {
            Button(String(localized: "Add new set", bundle: .module), action: onAddNewSaunaSetButtonClick)
        }
    }

    private var afterwordSection: some View {
        Section {
            TextField(
                String(localized: "Optional", bundle: .module),
                text: .init(
                    get: {
                        sakatsu.afterword ?? ""
                    }, set: { newValue in
                        onAfterwordChange(newValue)
                    }
                ),
                axis: .vertical
            )
        } header: {
            Text("Afterword", bundle: .module)
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
            .onDelete { offsets in
                onTemperatureDelete(offsets)
            }
            Button(String(localized: "Add new sauna temperatures", bundle: .module), action: onAddNewTemperatureButtonClick)
                .font(.footnote)
        } header: {
            Text("Temperatures", bundle: .module)
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
                TextField(String(localized: "Optional", bundle: .module), text: .init(get: {
                    saunaSetItem.title
                }, set: { newValue in
                    onTitleChange(saunaSetIndex, newValue)
                }))
            }
            TextField(String(localized: "Optional", bundle: .module), value: .init(get: {
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
                TextField(String(localized: "Optional", bundle: .module), text: .init(get: {
                    saunaTemperature.title
                }, set: { newValue in
                    onTitleChange(saunaTemperatureIndex, newValue)
                }))
            }
            TextField(String(localized: "Optional", bundle: .module), value: .init(get: {
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
            onCoolBathTimeChange: { _, _ in },
            onRelaxationTitleChange: { _, _ in },
            onRelaxationTimeChange: { _, _ in },
            onRemoveSaunaSetButtonClick: { _ in },
            onAfterwordChange: { _ in },
            onTemperatureTitleChange: { _, _ in },
            onTemperatureChange: { _, _ in },
            onTemperatureDelete: { _ in },
            onAddNewTemperatureButtonClick: {}
        )
    }
}
#endif
