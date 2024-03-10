import SwiftUI
import LogCore
import UICore

// MARK: Action

enum SettingsScreenAction {
    case onErrorAlertDismiss
}

// MARK: - View

package struct SettingsScreen: View {
    @StateObject private var viewModel: SettingsViewModel

    package var body: some View {
        SettingsView(
            defaultSaunaTimes: viewModel.uiState.defaultSaunaTimes,
            send: { action in
                viewModel.send(.view(action))
            }
        )
        .navigationTitle(String(localized: "Settings", bundle: .module))
        .errorAlert(
            error: viewModel.uiState.settingsError,
            onDismiss: { viewModel.send(.screen(.onErrorAlertDismiss)) }
        )
    }

    @MainActor
    package init(onLicensesButtonClick: @escaping () -> Void) {
        let message = "\(#file) \(#function)"
        Logger.standard.debug("\(message, privacy: .public)")
        self._viewModel = StateObject(wrappedValue: SettingsViewModel(
            onLicensesButtonClick: onLicensesButtonClick
        ))
    }
}

// MARK: - Previews

#if DEBUG
#Preview {
    NavigationStack {
        SettingsScreen(onLicensesButtonClick: {})
    }
}
#endif
