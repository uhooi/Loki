import SwiftUI
import LogCore

// MARK: Actions

enum SakatsuReportScreenAction {
}

enum SakatsuReportScreenAsyncAction {
}

// MARK: - View

struct SakatsuReportScreen: View {
    @StateObject private var viewModel: SakatsuReportViewModel

    @Environment(\.dismiss) private var dismiss // swiftlint:disable:this attributes

    var body: some View {
        SakatsuReportView(
            send: { action in
            },
        )
        .navigationTitle(String(localized: "Sakatsu report", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .sakatsuReportScreenToolbar(onDoneButtonClick: { dismiss() })
    }
    
    init(
    ) {
        Logger.standard.debug("\(#function, privacy: .public)")

        self._viewModel = StateObject(wrappedValue: SakatsuReportViewModel(
        ))
    }
}

// MARK: - Privates

private extension View {
    func sakatsuReportScreenToolbar(
        onDoneButtonClick: @escaping () -> Void,
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    onDoneButtonClick()
                } label: {
                    Text("Done", bundle: .module)
                        .bold()
                }
            }
        }
    }
}
