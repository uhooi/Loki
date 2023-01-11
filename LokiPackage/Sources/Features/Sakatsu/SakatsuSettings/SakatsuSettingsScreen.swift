import SwiftUI
import UICore
import SakatsuData

struct SakatsuSettingsScreen: View {
    @StateObject private var viewModel: SakatsuSettingsViewModel<DefaultSaunaTimeUserDefaultsClient, SakatsuValidator>

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            SakatsuSettingsView(
                defaultSaunaTimes: viewModel.uiState.defaultSaunaTimes,
                onDefaultSaunaTimeChange: { defaultSaunaTime in
                    viewModel.onDefaultSaunaTimeChange(defaultSaunaTime: defaultSaunaTime)
                }, onDefaultCoolBathTimeChange: { defaultCoolBathTime in
                    viewModel.onDefaultCoolBathTimeChange(defaultCoolBathTime: defaultCoolBathTime)
                }, onDefaultRelaxationTimeChange: { defaultRelaxationTime in
                    viewModel.onDefaultRelaxationTimeChange(defaultRelaxationTime: defaultRelaxationTime)
                }
            )
            .navigationTitle(String(localized: "Settings", bundle: .module))
            .sakatsuSettingsScreenToolbar(onCloseButtonClick: { dismiss() })
            .errorAlert(
                error: viewModel.uiState.sakatsuSettingsError,
                onDismiss: { viewModel.onErrorAlertDismiss() }
            )
        }
    }

    init() {
        self._viewModel = StateObject(wrappedValue: SakatsuSettingsViewModel())
    }
}

private extension View {
    func sakatsuSettingsScreenToolbar(
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
struct SakatsuSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SakatsuSettingsScreen()
    }
}
#endif
