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
    
    var body: some View {
        SakatsuReportView(
            send: { action in
            },
        )
        .navigationTitle(String(localized: "Sakatsu report", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    init(
    ) {
        Logger.standard.debug("\(#function, privacy: .public)")

        self._viewModel = StateObject(wrappedValue: SakatsuReportViewModel(
        ))
    }
}
