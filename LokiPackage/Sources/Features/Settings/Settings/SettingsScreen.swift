import SwiftUI
import UICore
import SakatsuData

public struct SettingsScreen: View {
    @StateObject private var viewModel: SettingsViewModel<DefaultSaunaTimeUserDefaultsClient, SakatsuValidator>

    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        NavigationStack {
            SettingsView(
                defaultSaunaTimes: viewModel.uiState.defaultSaunaTimes,
                onDefaultSaunaTimeChange: { defaultSaunaTime in
                    viewModel.onDefaultSaunaTimeChange(defaultSaunaTime: defaultSaunaTime)
                }, onDefaultCoolBathTimeChange: { defaultCoolBathTime in
                    viewModel.onDefaultCoolBathTimeChange(defaultCoolBathTime: defaultCoolBathTime)
                }, onDefaultRelaxationTimeChange: { defaultRelaxationTime in
                    viewModel.onDefaultRelaxationTimeChange(defaultRelaxationTime: defaultRelaxationTime)
                }
            )
            .navigationTitle(L10n.settings)
            .settingsScreenToolbar(onCloseButtonClick: { dismiss() })
            .errorAlert(
                error: viewModel.uiState.settingsError,
                onDismiss: { viewModel.onErrorAlertDismiss() }
            )
        }
    }

    public init() {
        self._viewModel = StateObject(wrappedValue: SettingsViewModel())
    }
}

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

#if DEBUG
struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
#endif
