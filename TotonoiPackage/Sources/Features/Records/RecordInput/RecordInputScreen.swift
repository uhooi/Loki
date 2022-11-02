import Foundation
import SwiftUI
import RecordsData

struct RecordInputScreen: View {
    @StateObject private var viewModel = RecordInputViewModel()
    
    var body: some View {
        RecordInputView(
            sakatsu: viewModel.uiState.sakatsu,
            onFacilityNameChange: { facilityName in
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
        .navigationTitle("サ活")
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
    @State private var sakatsu: Sakatsu = .init(
        facilityName: "",
        visitingDate: .now,
        saunaSets: [],
        comment: nil
    )
    
    // FIXME: Use `let`
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
            Section(header: Text("サウナ🧖")) {
                HStack {
                    Text("時間")
                    TextField("300", value: .init(get: {
                        sakatsu.saunaSets.first?.sauna.time // TODO:
                    }, set: { newValue in
                        onSaunaTimeChange(newValue)
                    }), format: .number)
                    .keyboardType(.numberPad)
                    Text("秒")
                }
            }
            Section(header: Text("水風呂💧")) {
                HStack {
                    Text("時間")
                    TextField("30", value: .init(get: {
                        sakatsu.saunaSets.first?.coolBath.time // TODO:
                    }, set: { newValue in
                        onCoolBathTimeChange(newValue)
                    }), format: .number)
                    .keyboardType(.numberPad)
                    Text("秒")
                }
            }
            Section(header: Text("休憩🍃")) {
                HStack {
                    Text("時間")
                    TextField("600", value: .init(get: {
                        sakatsu.saunaSets.first?.relaxation.time // TODO:
                    }, set: { newValue in
                        onRelaxationTimeChange(newValue)
                    }), format: .number)
                    .keyboardType(.numberPad)
                    Text("秒")
                }
            }
        }
    }
    
    init(
        sakatsu: Sakatsu,
        onFacilityNameChange: @escaping (String) -> Void,
        onVisitingDateChange: @escaping (Date) -> Void,
        onSaunaTimeChange: @escaping (TimeInterval?) -> Void,
        onCoolBathTimeChange: @escaping (TimeInterval?) -> Void,
        onRelaxationTimeChange: @escaping (TimeInterval?) -> Void
    ) {
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
            onFacilityNameChange: { facilityName in
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
