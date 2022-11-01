import Foundation
import SwiftUI
import RecordsData

struct RecordInputScreen: View {
    @StateObject private var viewModel = RecordInputViewModel()
    
    var body: some View {
        RecordInputView(
            facilityName: viewModel.uiState.sakatsu.facilityName,
            visitingDate: viewModel.uiState.sakatsu.visitingDate,
            saunaTime: viewModel.uiState.sakatsu.saunaSets.first?.sauna.time, // TODO:
            onSubmitFacilityName: { facilityName in
                viewModel.onSubmitFacilityName(facilityName: facilityName)
            }, onSubmitVisitingDate: { visitingDate in
                viewModel.onSubmitVisitingDate(visitingDate: visitingDate)
            }, onSubmitSaunaTime: { saunaTime in
                viewModel.onSubmitSaunaTime(saunaTime: saunaTime)
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
    @State private var facilityName: String = ""
    @State private var visitingDate: Date = .now
    @State private var saunaTime: TimeInterval? = nil
    @State private var coolBathTime: TimeInterval? = nil
    @State private var relaxationTime: TimeInterval? = nil
    
    // FIXME: Use `let`
    private var onSubmitFacilityName: ((String) -> Void) = { _ in }
    private var onSubmitVisitingDate: ((Date) -> Void) = { _ in }
    private var onSubmitSaunaTime: ((TimeInterval?) -> Void) = { _ in }
    private var onSubmitCoolBathTime: ((TimeInterval?) -> Void) = { _ in }
    private var onSubmitRelaxationTime: ((TimeInterval?) -> Void) = { _ in }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("施設名")
                    TextField("施設名", text: $facilityName)
                        .onSubmit {
                            onSubmitFacilityName(facilityName)
                        }
                }
                DatePicker(
                    "訪問日",
                    selection: $visitingDate,
                    displayedComponents: [.date]
                )
                .onSubmit {
                    onSubmitVisitingDate(visitingDate)
                }
            }
            Section(header: Text("サウナ🧖")) {
                HStack {
                    Text("時間（秒）")
                    TextField("時間", value: $saunaTime, format: .number)
                        .keyboardType(.numberPad)
                        .onSubmit {
                            onSubmitSaunaTime(saunaTime)
                        }
                }
            }
            Section(header: Text("水風呂💧")) {
                HStack {
                    Text("時間（秒）")
                    TextField("時間", value: $coolBathTime, format: .number)
                        .keyboardType(.numberPad)
                        .onSubmit {
                            onSubmitCoolBathTime(coolBathTime)
                        }
                }
            }
            Section(header: Text("休憩🍃")) {
                HStack {
                    Text("時間（秒）")
                    TextField("時間", value: $relaxationTime, format: .number)
                        .keyboardType(.numberPad)
                        .onSubmit {
                            onSubmitRelaxationTime(relaxationTime)
                        }
                }
            }
        }
    }
    
    init(
        facilityName: String,
        visitingDate: Date,
        saunaTime: TimeInterval? = nil,
        onSubmitFacilityName: @escaping (String) -> Void,
        onSubmitVisitingDate: @escaping (Date) -> Void,
        onSubmitSaunaTime: @escaping (TimeInterval?) -> Void
    ) {
        self.facilityName = facilityName
        self.visitingDate = visitingDate
        self.saunaTime = saunaTime
        self.onSubmitFacilityName = onSubmitFacilityName
        self.onSubmitVisitingDate = onSubmitVisitingDate
        self.onSubmitSaunaTime = onSubmitSaunaTime
    }
}

struct RecordInputView_Previews: PreviewProvider {
    static var previews: some View {
        RecordInputView(
            facilityName: Sakatsu.preview.facilityName,
            visitingDate: Sakatsu.preview.visitingDate,
            saunaTime: SaunaSet.preview.sauna.time,
            onSubmitFacilityName: { facilityName in
                print("facilityName: \(facilityName)")
            }, onSubmitVisitingDate: { visitingDate in
                print("visitingDate: \(visitingDate)")
            }, onSubmitSaunaTime: { saunaTime in
                print("saunaTime: \(saunaTime?.formatted() ?? "")")
            }
        )
    }
}
