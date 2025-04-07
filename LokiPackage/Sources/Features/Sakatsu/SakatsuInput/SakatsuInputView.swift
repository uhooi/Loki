import SwiftUI
import Algorithms
import SakatsuData

// MARK: Actions

enum SakatsuInputViewAction {
    case onAddNewSaunaSetButtonClick
    case onFacilityNameChange(_ facilityName: String)
    case onVisitingDateChange(_ visitingDate: Date)
    case onForewordChange(_ foreword: String?)
    case onSaunaTitleChange(saunaSetIndex: Int, _ saunaTitle: String)
    case onSaunaTimeChange(saunaSetIndex: Int, _ saunaTime: TimeInterval?)
    case onCoolBathTitleChange(saunaSetIndex: Int, _ coolBathTitle: String)
    case onCoolBathTimeChange(saunaSetIndex: Int, _ coolBathTime: TimeInterval?)
    case onRelaxationTitleChange(saunaSetIndex: Int, _ relaxationTitle: String)
    case onRelaxationTimeChange(saunaSetIndex: Int, _ relaxationTime: TimeInterval?)
    case onRemoveSaunaSetButtonClick(saunaSetIndex: Int)
    case onAfterwordChange(_ afterword: String?)
    case onTemperatureTitleChange(temperatureIndex: Int, _ temperatureTitle: String)
    case onTemperatureChange(temperatureIndex: Int, _ temperature: Decimal?)
    case onTemperatureDelete(_ offsets: IndexSet)
    case onAddNewTemperatureButtonClick
}

enum SakatsuInputViewAsyncAction {
}

// MARK: - View

struct SakatsuInputView: View {
    let sakatsu: Sakatsu
    let send: (SakatsuInputViewAction) -> Void

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
                    send(.onFacilityNameChange(newValue))
                }))
            }

            DatePicker(
                String(localized: "Visiting date", bundle: .module),
                selection: .init(get: {
                    sakatsu.visitingDate
                }, set: { newValue in
                    send(.onVisitingDateChange(newValue))
                }),
                displayedComponents: [.date],
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
                        send(.onForewordChange(newValue))
                    }
                ),
                axis: .vertical,
            )
        } header: {
            Text("Foreword", bundle: .module)
        }
    }

    var saunaSetSections: some View {
        ForEach(sakatsu.saunaSets.indexed(), id: \.element.id) { saunaSetIndex, saunaSet in
            Section {
                saunaSetItemTimeInputView(
                    saunaSetIndex: saunaSetIndex,
                    saunaSetItem: saunaSet.sauna,
                    onTitleChange: { title in
                        send(.onSaunaTitleChange(saunaSetIndex: saunaSetIndex, title))
                    }, onTimeChange: { time in
                        send(.onSaunaTimeChange(saunaSetIndex: saunaSetIndex, time))
                    },
                )

                saunaSetItemTimeInputView(
                    saunaSetIndex: saunaSetIndex,
                    saunaSetItem: saunaSet.coolBath,
                    onTitleChange: { title in
                        send(.onCoolBathTitleChange(saunaSetIndex: saunaSetIndex, title))
                    }, onTimeChange: { time in
                        send(.onCoolBathTimeChange(saunaSetIndex: saunaSetIndex, time))
                    },
                )

                saunaSetItemTimeInputView(
                    saunaSetIndex: saunaSetIndex,
                    saunaSetItem: saunaSet.relaxation,
                    onTitleChange: { title in
                        send(.onRelaxationTitleChange(saunaSetIndex: saunaSetIndex, title))
                    }, onTimeChange: { time in
                        send(.onRelaxationTimeChange(saunaSetIndex: saunaSetIndex, time))
                    },
                )
            } header: {
                Text("Set \(saunaSetIndex + 1)", bundle: .module)
            } footer: {
                Button(role: .destructive) {
                    send(.onRemoveSaunaSetButtonClick(saunaSetIndex: saunaSetIndex))
                } label: {
                    Text("Delete set", bundle: .module)
                        .font(.footnote)
                }
            }
        }
    }

    var newSaunaSetSection: some View {
        Section {
            Button(String(localized: "Add new set", bundle: .module)) {
                send(.onAddNewSaunaSetButtonClick)
            }
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
                        send(.onAfterwordChange(newValue))
                    },
                ),
                axis: .vertical,
            )
        } header: {
            Text("Afterword", bundle: .module)
        }
    }

    var temperaturesSection: some View {
        Section {
            ForEach(sakatsu.saunaTemperatures.indexed(), id: \.element.id) { saunaTemperatureIndex, saunaTemperature in
                saunaTemperatureInputView(
                    saunaTemperatureIndex: saunaTemperatureIndex,
                    saunaTemperature: saunaTemperature,
                    onTitleChange: { title in
                        send(.onTemperatureTitleChange(temperatureIndex: saunaTemperatureIndex, title))
                    }, onTemperatureChange: { temperature in
                        send(.onTemperatureChange(temperatureIndex: saunaTemperatureIndex, temperature))
                    },
                )
            }
            .onDelete { offsets in
                send(.onTemperatureDelete(offsets))
            }

            Button {
                send(.onAddNewTemperatureButtonClick)
            } label: {
                Text("Add new sauna temperatures", bundle: .module)
                    .font(.footnote)
            }
        } header: {
            Text("Temperatures", bundle: .module)
        }
    }

    func saunaSetItemTimeInputView(
        saunaSetIndex: Int,
        saunaSetItem: any SaunaSetItemProtocol,
        onTitleChange: @escaping (_ title: String) -> Void,
        onTimeChange: @escaping (_ time: TimeInterval?) -> Void,
    ) -> some View {
        HStack {
            HStack(spacing: 0) {
                Text(saunaSetItem.emoji)

                TextField(String(localized: "Optional", bundle: .module), text: .init(get: {
                    saunaSetItem.title
                }, set: { newValue in
                    onTitleChange(newValue)
                }))
            }

            TextField(String(localized: "Optional", bundle: .module), value: .init(get: {
                saunaSetItem.time
            }, set: { newValue in
                onTimeChange(newValue)
            }), format: .number)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)

            Text(saunaSetItem.unit)
        }
    }

    func saunaTemperatureInputView(
        saunaTemperatureIndex: Int,
        saunaTemperature: SaunaTemperature,
        onTitleChange: @escaping (_ temperatureTitle: String) -> Void,
        onTemperatureChange: @escaping (_ temperature: Decimal?) -> Void,
    ) -> some View {
        HStack {
            HStack(spacing: 0) {
                Text(saunaTemperature.emoji)

                TextField(String(localized: "Optional", bundle: .module), text: .init(get: {
                    saunaTemperature.title
                }, set: { newValue in
                    onTitleChange(newValue)
                }))
            }

            TextField(String(localized: "Optional", bundle: .module), value: .init(get: {
                saunaTemperature.temperature
            }, set: { newValue in
                onTemperatureChange(newValue)
            }), format: .number)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)

            Text("℃", bundle: .module)
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview {
    SakatsuInputView(
        sakatsu: .preview,
        send: { _ in },
    )
}
#endif
