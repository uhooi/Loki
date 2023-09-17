import SwiftUI
import LogCore
import UICore

public struct SettingsScreen: View {
    private let onLicensesButtonClick: () -> Void
    @StateObject private var viewModel: SettingsViewModel

    public var body: some View {
        SettingsView(
            defaultSaunaTimes: viewModel.uiState.defaultSaunaTimes,
            onDefaultSaunaTimeChange: { defaultSaunaTime in
                viewModel.send(.onDefaultSaunaTimeChange(defaultSaunaTime: defaultSaunaTime))
            }, onDefaultCoolBathTimeChange: { defaultCoolBathTime in
                viewModel.send(.onDefaultCoolBathTimeChange(defaultCoolBathTime: defaultCoolBathTime))
            }, onDefaultRelaxationTimeChange: { defaultRelaxationTime in
                viewModel.send(.onDefaultRelaxationTimeChange(defaultRelaxationTime: defaultRelaxationTime))
            }, onLicensesButtonClick: {
                onLicensesButtonClick()
            }
        )
        .navigationTitle(String(localized: "Settings", bundle: .module))
        .errorAlert(
            error: viewModel.uiState.settingsError,
            onDismiss: { viewModel.send(.onErrorAlertDismiss) }
        )
    }

    @MainActor
    public init(onLicensesButtonClick: @escaping () -> Void) {
        let message = "\(#file) \(#function)"
        Logger.standard.debug("\(message, privacy: .public)")
        self.onLicensesButtonClick = onLicensesButtonClick
        self._viewModel = StateObject(wrappedValue: SettingsViewModel())
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        SettingsScreen(onLicensesButtonClick: {})
    }
}
