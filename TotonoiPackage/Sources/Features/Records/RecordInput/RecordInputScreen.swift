import Foundation
import SwiftUI
import RecordsData

struct RecordInputScreen: View {
    @StateObject private var viewModel = RecordInputViewModel()
    
    var body: some View {
        RecordInputView(
            sakatsu: viewModel.uiState.sakatsu,
            onAddNewSaunaSetButtonClick: {
                viewModel.onAddNewSaunaSetButtonClick()
            }, onFacilityNameChange: { facilityName in
                viewModel.onFacilityNameChange(facilityName: facilityName)
            }, onVisitingDateChange: { visitingDate in
                viewModel.onVisitingDateChange(visitingDate: visitingDate)
            }, onSaunaTimeChange: { saunaSetIndex, saunaTime in
                viewModel.onSaunaTimeChange(saunaSetIndex: saunaSetIndex, saunaTime: saunaTime)
            }, onCoolBathTimeChange: { saunaSetIndex, coolBathTime in
                viewModel.onCoolBathTimeChange(saunaSetIndex: saunaSetIndex, coolBathTime: coolBathTime)
            }, onRelaxationTimeChange: { saunaSetIndex, relaxationTime in
                viewModel.onRelaxationTimeChange(saunaSetIndex: saunaSetIndex, relaxationTime: relaxationTime)
            }
        )
        .navigationTitle("サ活登録")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("保存") {
                    viewModel.onSaveButtonClick()
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
    private var onAddNewSaunaSetButtonClick: (() -> Void) = {}
    private var onFacilityNameChange: ((String) -> Void) = { _ in }
    private var onVisitingDateChange: ((Date) -> Void) = { _ in }
    private var onSaunaTimeChange: ((Int, TimeInterval?) -> Void) = { _, _ in }
    private var onCoolBathTimeChange: ((Int, TimeInterval?) -> Void) = { _, _ in }
    private var onRelaxationTimeChange: ((Int, TimeInterval?) -> Void) = { _, _ in }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("施設名")
                    TextField("", text: .init(get: {
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
            ForEach(0..<sakatsu.saunaSets.count, id: \.self) { saunaSetIndex in
                let saunaSet = sakatsu.saunaSets[saunaSetIndex]
                Section(header: Text("\(saunaSetIndex + 1)セット目")) { // TODO: Use real number
                    HStack {
                        Text("サウナ🧖")
                        TextField("オプション", value: .init(get: {
                            saunaSet.sauna.time.map { $0 / 60 }
                        }, set: { newValue in
                            onSaunaTimeChange(saunaSetIndex, newValue)
                        }), format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        Text("分")
                    }
                    HStack {
                        Text("水風呂💧")
                        TextField("オプション", value: .init(get: {
                            saunaSet.coolBath.time
                        }, set: { newValue in
                            onCoolBathTimeChange(saunaSetIndex, newValue)
                        }), format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        Text("秒")
                    }
                    HStack {
                        Text("休憩🍃")
                        TextField("オプション", value: .init(get: {
                            saunaSet.relaxation.time.map { $0 / 60 }
                        }, set: { newValue in
                            onRelaxationTimeChange(saunaSetIndex, newValue)
                        }), format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        Text("分")
                    }
                }
            }
            Section {
                Button("新しいセットを追加") {
                    onAddNewSaunaSetButtonClick()
                }
            }
        }
    }
    
    init(
        sakatsu: Sakatsu,
        onAddNewSaunaSetButtonClick: @escaping () -> Void,
        onFacilityNameChange: @escaping (String) -> Void,
        onVisitingDateChange: @escaping (Date) -> Void,
        onSaunaTimeChange: @escaping (Int, TimeInterval?) -> Void,
        onCoolBathTimeChange: @escaping (Int, TimeInterval?) -> Void,
        onRelaxationTimeChange: @escaping (Int, TimeInterval?) -> Void
    ) {
        self.onAddNewSaunaSetButtonClick = onAddNewSaunaSetButtonClick
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
            onAddNewSaunaSetButtonClick: {
                print("onAddNewSaunaSetButtonClick")
            }, onFacilityNameChange: { facilityName in
                print("facilityName: \(facilityName)")
            }, onVisitingDateChange: { visitingDate in
                print("visitingDate: \(visitingDate)")
            }, onSaunaTimeChange: { saunaSetIndex, saunaTime in
                print("saunaSetIndex: \(saunaSetIndex)")
                print("saunaTime: \(saunaTime?.formatted() ?? "")")
            }, onCoolBathTimeChange: { saunaSetIndex, coolBathTime in
                print("saunaSetIndex: \(saunaSetIndex)")
                print("coolBathTime: \(coolBathTime?.formatted() ?? "")")
            }, onRelaxationTimeChange: { saunaSetIndex, relaxationTime in
                print("saunaSetIndex: \(saunaSetIndex)")
                print("relaxationTime: \(relaxationTime?.formatted() ?? "")")
            }
        )
    }
}
