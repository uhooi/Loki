import Foundation
import SwiftUI
import RecordsData

struct RecordInputScreen: View {
    @StateObject private var viewModel = RecordInputViewModel()
    
    var body: some View {
        RecordInputView(
            sakatsu: viewModel.uiState.sakatsu,
            didTapAddNewSaunaSetButton: {
                viewModel.didTapAddNewSaunaSetButton()
            }, onFacilityNameChange: { facilityName in
                viewModel.onFacilityNameChange(facilityName: facilityName)
            }, onVisitingDateChange: { visitingDate in
                viewModel.onVisitingDateChange(visitingDate: visitingDate)
            }, onSaunaTimeChange: { saunaTime in
                viewModel.onSaunaTimeChange(saunaTime: saunaTime)
            }, onCoolBathTimeChange: { coolBathTime in
                viewModel.onCoolBathTimeChange(coolBathTime: coolBathTime)
            }, onRelaxationTimeChange: { relaxationTime in
                viewModel.onRelaxationTimeChange(relaxationTime: relaxationTime)
            }
        )
        .navigationTitle("サ活登録")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("保存") {
                    viewModel.didTapSaveButton()
                }
            }
        }
    }
}

struct RecordInputScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecordInputScreen()
        }
    }
}

private struct RecordInputView: View {
    private var sakatsu: Sakatsu = .init(
        facilityName: "",
        visitingDate: .now,
        saunaSets: [.init(sauna: .init(time: nil), coolBath: .init(time: nil), relaxation: .init(time: nil, place: nil, way: nil))],
        comment: nil
    )
    
    // FIXME: Use `let`
    private var didTapAddNewSaunaSetButton: (() -> Void) = {}
    private var onFacilityNameChange: ((String) -> Void) = { _ in }
    private var onVisitingDateChange: ((Date) -> Void) = { _ in }
    private var onSaunaTimeChange: ((TimeInterval?) -> Void) = { _ in }
    private var onCoolBathTimeChange: ((TimeInterval?) -> Void) = { _ in }
    private var onRelaxationTimeChange: ((TimeInterval?) -> Void) = { _ in }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("施設名")
                    TextField("施設名", text: .init(get: {
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
            ForEach(sakatsu.saunaSets) { saunaSet in
                Section(header: Text("1セット目")) { // TODO: Use real number
                    HStack {
                        Text("サウナ🧖")
                        TextField("5", value: .init(get: {
                            saunaSet.sauna.time // TODO: `/ 60`
                        }, set: { newValue in
                            onSaunaTimeChange(newValue)
                        }), format: .number)
                        .keyboardType(.numberPad)
                        Text("分")
                    }
                    HStack {
                        Text("水風呂💧")
                        TextField("30", value: .init(get: {
                            saunaSet.coolBath.time
                        }, set: { newValue in
                            onCoolBathTimeChange(newValue)
                        }), format: .number)
                        .keyboardType(.numberPad)
                        Text("秒")
                    }
                    HStack {
                        Text("休憩🍃")
                        TextField("10", value: .init(get: {
                            saunaSet.relaxation.time // TODO: `/ 60`
                        }, set: { newValue in
                            onRelaxationTimeChange(newValue)
                        }), format: .number)
                        .keyboardType(.numberPad)
                        Text("分")
                    }
                }
            }
            Section {
                Button("新しいセットを追加") {
                    didTapAddNewSaunaSetButton()
                }
            }
        }
    }
    
    init(
        sakatsu: Sakatsu,
        didTapAddNewSaunaSetButton: @escaping () -> Void,
        onFacilityNameChange: @escaping (String) -> Void,
        onVisitingDateChange: @escaping (Date) -> Void,
        onSaunaTimeChange: @escaping (TimeInterval?) -> Void,
        onCoolBathTimeChange: @escaping (TimeInterval?) -> Void,
        onRelaxationTimeChange: @escaping (TimeInterval?) -> Void
    ) {
        self.didTapAddNewSaunaSetButton = didTapAddNewSaunaSetButton
        self.sakatsu = sakatsu
        self.onFacilityNameChange = onFacilityNameChange
        self.onVisitingDateChange = onVisitingDateChange
        self.onSaunaTimeChange = onSaunaTimeChange
        self.onCoolBathTimeChange = onCoolBathTimeChange
        self.onRelaxationTimeChange = onRelaxationTimeChange
    }
}

struct RecordInputView_Previews: PreviewProvider {
    static var previews: some View {
        RecordInputView(
            sakatsu: Sakatsu.preview,
            didTapAddNewSaunaSetButton: {
                print("didTapAddNewSaunaSetButton")
            }, onFacilityNameChange: { facilityName in
                print("facilityName: \(facilityName)")
            }, onVisitingDateChange: { visitingDate in
                print("visitingDate: \(visitingDate)")
            }, onSaunaTimeChange: { saunaTime in
                print("saunaTime: \(saunaTime?.formatted() ?? "")")
            }, onCoolBathTimeChange: { coolBathTime in
                print("coolBathTime: \(coolBathTime?.formatted() ?? "")")
            }, onRelaxationTimeChange: { relaxationTime in
                print("relaxationTime: \(relaxationTime?.formatted() ?? "")")
            }
        )
    }
}
