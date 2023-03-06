import SwiftUI
import SakatsuData
import UICore

public struct SettingsScreen<Router: SettingsRouterProtocol>: View {
    private let router: Router
    @StateObject private var viewModel: SettingsViewModel<DefaultSaunaTimeUserDefaultsClient, SakatsuValidator>

    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        SettingsView(
            defaultSaunaTimes: viewModel.uiState.defaultSaunaTimes,
            licensesScreen: router.licensesScreen(),
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

    public init(router: Router) {
        self.router = router
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
        NavigationStack {
            SettingsScreen(router: SettingsRouterMock.shared)
        }
    }
}
#endif
