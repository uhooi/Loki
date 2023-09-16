import SwiftUI
import Algorithms
import SakatsuData

struct SakatsuInputView: View {
    let sakatsu: Sakatsu

    let onAddNewSaunaSetButtonClick: () -> Void
    let onFacilityNameChange: (_ facilityName: String) -> Void
    let onVisitingDateChange: (_ visitingDate: Date) -> Void
    let onForewordChange: (_ foreword: String?) -> Void
    let onSaunaTitleChange: (_ saunaSetIndex: Int, _ saunaTitle: String) -> Void
    let onSaunaTimeChange: (_ saunaSetIndex: Int, _ saunaTime: TimeInterval?) -> Void
    let onCoolBathTitleChange: (_ saunaSetIndex: Int, _ coolBathTitle: String) -> Void
    let onCoolBathTimeChange: (_ saunaSetIndex: Int, _ coolBathTime: TimeInterval?) -> Void
    let onRelaxationTitleChange: (_ saunaSetIndex: Int, _ relaxationTitle: String) -> Void
    let onRelaxationTimeChange: (_ saunaSetIndex: Int, _ relaxationTime: TimeInterval?) -> Void
    let onRemoveSaunaSetButtonClick: (_ saunaSetIndex: Int) -> Void
    let onAfterwordChange: (_ afterword: String?) -> Void
    let onTemperatureTitleChange: (_ temperatureIndex: Int, _ temperatureTitle: String) -> Void
    let onTemperatureChange: (_ temperatureIndex: Int, _ temperature: Decimal?) -> Void
    let onTemperatureDelete: (_ offsets: IndexSet) -> Void
    let onAddNewTemperatureButtonClick: () -> Void

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
}

// MARK: - Privates

private extension SakatsuInputView {
    var generalSection: some View {
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

    var forewordSection: some View {
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

    var saunaSetSections: some View {
        ForEach(sakatsu.saunaSets.indexed(), id: \.element) { saunaSetIndex, saunaSet in
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

    var newSaunaSetSection: some View {
        Section {
            Button(String(localized: "Add new set", bundle: .module), action: onAddNewSaunaSetButtonClick)
        }
    }

    var afterwordSection: some View {
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

    var temperaturesSection: some View {
        Section {
            ForEach(sakatsu.saunaTemperatures.indexed(), id: \.element) { saunaTemperatureIndex, saunaTemperature in
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

    func saunaSetItemTimeInputView(
        saunaSetIndex: Int,
        saunaSetItem: any SaunaSetItemProtocol,
        onTitleChange: @escaping (_ saunaSetIndex: Int, _ title: String) -> Void,
        onTimeChange: @escaping (_ saunaSetIndex: Int, _ time: TimeInterval?) -> Void
    ) -> some View {
        HStack {
            HStack(spacing: 0) {
                Text(saunaSetItem.emoji)
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

    func saunaTemperatureInputView(
        saunaTemperatureIndex: Int,
        saunaTemperature: SaunaTemperature,
        onTitleChange: @escaping (_ temperatureIndex: Int, _ temperatureTitle: String) -> Void,
        onTemperatureChange: @escaping (_ temperatureIndex: Int, _ temperature: Decimal?) -> Void
    ) -> some View {
        HStack {
            HStack(spacing: 0) {
                Text(saunaTemperature.emoji)
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
            Text("℃", bundle: .module)
        }
    }
}

// MARK: - Previews

#Preview {
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
