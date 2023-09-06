import SwiftUI
import UICore

public struct SettingsScreen: View {
    private let onLicensesButtonClick: () -> Void
    @StateObject private var viewModel: SettingsViewModel

    @Environment(\.dismiss) private var dismiss

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
        .navigationTitle(L10n.settings)
        .settingsScreenToolbar(onCloseButtonClick: { dismiss() })
        .errorAlert(
            error: viewModel.uiState.settingsError,
            onDismiss: { viewModel.send(.onErrorAlertDismiss) }
        )
    }

    @MainActor
    public init(onLicensesButtonClick: @escaping () -> Void) {
        self.onLicensesButtonClick = onLicensesButtonClick
        self._viewModel = StateObject(wrappedValue: SettingsViewModel())
    }
}

// MARK: - Privates

private extension View {
    func settingsScreenToolbar(
        onCloseButtonClick: @escaping () -> Void
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    onCloseButtonClick()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        SettingsScreen(onLicensesButtonClick: {})
    }
}
