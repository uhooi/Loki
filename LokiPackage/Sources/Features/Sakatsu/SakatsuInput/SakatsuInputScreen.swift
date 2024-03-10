import SwiftUI
import LogCore
import UICore

// MARK: Action

enum SakatsuInputScreenAction {
    case onSaveButtonClick
    case onErrorAlertDismiss
    case onCancelButtonClick
}

// MARK: - View

struct SakatsuInputScreen: View {
    @StateObject private var viewModel: SakatsuInputViewModel

    var body: some View {
        SakatsuInputView(
            sakatsu: viewModel.uiState.sakatsu,
            send: { action in
                viewModel.send(.view(action))
            }
        )
        .navigationTitle(String(localized: "Register Sakatsu", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
        .sakatsuInputScreenToolbar(
            saveButtonDisabled: viewModel.uiState.sakatsu.facilityName.isEmpty,
            onSaveButtonClick: { viewModel.send(.screen(.onSaveButtonClick)) },
            onCancelButtonClick: { viewModel.send(.screen(.onCancelButtonClick)) }
        )
        .errorAlert(
            error: viewModel.uiState.sakatsuInputError,
            onDismiss: { viewModel.send(.screen(.onErrorAlertDismiss)) }
        )
    }

    @MainActor
    init(
        sakatsuEditMode: SakatsuEditMode,
        onSakatsuSave: @escaping () -> Void,
        onCancelButtonClick: @escaping () -> Void
    ) {
        let message = "\(#file) \(#function)"
        Logger.standard.debug("\(message, privacy: .public)")
        self._viewModel = StateObject(wrappedValue: SakatsuInputViewModel(
            sakatsuEditMode: sakatsuEditMode,
            onSakatsuSave: onSakatsuSave,
            onCancelButtonClick: onCancelButtonClick
        ))
    }
}

// MARK: - Privates

private extension View {
    func sakatsuInputScreenToolbar(
        saveButtonDisabled: Bool,
        onSaveButtonClick: @escaping () -> Void,
        onCancelButtonClick: @escaping () -> Void
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "Save", bundle: .module), action: onSaveButtonClick)
                    .bold()
                    .disabled(saveButtonDisabled)
            }
            ToolbarItem(placement: .topBarLeading) {
                Button(String(localized: "Cancel", bundle: .module), role: .cancel, action: onCancelButtonClick)
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview {
    NavigationStack {
        SakatsuInputScreen(
            sakatsuEditMode: .edit(sakatsu: .preview),
            onSakatsuSave: {},
            onCancelButtonClick: {}
        )
    }
}
#endif
