import SwiftUI
import LogCore
import UICore

// MARK: Action

enum SettingsScreenAction {
    case onErrorAlertDismiss
    #if DEBUG
    case onDebugButtonClick
    #endif
}

// MARK: - View

package struct SettingsScreen: View {
    @StateObject private var viewModel: SettingsViewModel

    #if DEBUG
    @Environment(\.colorScheme) private var colorScheme // swiftlint:disable:this attributes
    #endif

    package var body: some View {
        SettingsView(
            defaultSaunaTimes: viewModel.uiState.defaultSaunaTimes,
            send: { action in
                viewModel.send(.view(action))
            }
        )
        .navigationTitle(String(localized: "Settings", bundle: .module))
        #if DEBUG
        .settingsScreenToolbar(
        colorScheme: colorScheme,
        onDebugButtonClick: { viewModel.send(.screen(.onDebugButtonClick)) }
        )
        #endif
        .errorAlert(
            error: viewModel.uiState.settingsError,
            onDismiss: { viewModel.send(.screen(.onErrorAlertDismiss)) }
        )
    }

    #if DEBUG
    @MainActor
    package init(
        onLicensesButtonClick: @escaping () -> Void,
        onDebugButtonClick: @escaping () -> Void
    ) {
        Logger.standard.debug("\(#function, privacy: .public)")

        self._viewModel = StateObject(wrappedValue: SettingsViewModel(
            onLicensesButtonClick: onLicensesButtonClick,
            onDebugButtonClick: onDebugButtonClick
        ))
    }
    #else
    @MainActor
    package init(
        onLicensesButtonClick: @escaping () -> Void
    ) {
        Logger.standard.debug("\(#function, privacy: .public)")

        self._viewModel = StateObject(wrappedValue: SettingsViewModel(
            onLicensesButtonClick: onLicensesButtonClick
        ))
    }
    #endif
}

// MARK: - Privates

private extension View {
    #if DEBUG
    func settingsScreenToolbar(
        colorScheme: ColorScheme,
        onDebugButtonClick: @escaping () -> Void
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onDebugButtonClick) {
                    Image(systemName: colorScheme != .dark ? "ladybug" : "ladybug.fill")
                }
            }
        }
    }
    #endif
}

// MARK: - Previews

#if DEBUG
#Preview {
    NavigationStack {
        SettingsScreen(
            onLicensesButtonClick: {},
            onDebugButtonClick: {}
        )
    }
}
#endif
