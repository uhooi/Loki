import SwiftUI
import SakatsuData
import UICore

public struct SakatsuListScreen: View {
    private let onSettingsButtonClick: () -> Void
    @StateObject private var viewModel: SakatsuListViewModel<SakatsuUserDefaultsClient>

    public var body: some View {
        SakatsuListView(
            sakatsus: viewModel.uiState.sakatsus,
            onCopySakatsuTextButtonClick: { sakatsuIndex in
                viewModel.onCopySakatsuTextButtonClick(sakatsuIndex: sakatsuIndex)
            }, onEditButtonClick: { sakatsuIndex in
                viewModel.onEditButtonClick(sakatsuIndex: sakatsuIndex)
            }, onDelete: { offsets in
                viewModel.onDelete(at: offsets)
            }
        )
        .navigationTitle(L10n.sakatsuList)
        .overlay(alignment: .bottomTrailing) {
            FAB(
                systemName: "plus",
                action: { viewModel.onAddButtonClick() }
            )
            .padding(16)
        }
        .sakatsuListScreenToolbar(
            onSettingsButtonClick: { onSettingsButtonClick() }
        )
        .sakatsuInputSheet(
            shouldShowSheet: viewModel.uiState.shouldShowInputScreen,
            selectedSakatsu: viewModel.uiState.selectedSakatsu,
            onDismiss: { viewModel.onInputScreenDismiss() },
            onSakatsuSave: { viewModel.onSakatsuSave() }
        )
        .copyingSakatsuTextAlert(
            sakatsuText: viewModel.uiState.sakatsuText,
            onDismiss: { viewModel.onCopyingSakatsuTextAlertDismiss() }
        )
        .errorAlert(
            error: viewModel.uiState.sakatsuListError,
            onDismiss: { viewModel.onErrorAlertDismiss() }
        )
    }

    public init(onSettingsButtonClick: @escaping () -> Void) {
        self.onSettingsButtonClick = onSettingsButtonClick
        self._viewModel = StateObject(wrappedValue: SakatsuListViewModel())
    }
}

private extension View {
    func sakatsuListScreenToolbar(
        onSettingsButtonClick: @escaping () -> Void
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    onSettingsButtonClick()
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
    }

    @MainActor
    func sakatsuInputSheet(
        shouldShowSheet: Bool,
        selectedSakatsu: Sakatsu?,
        onDismiss: @escaping () -> Void,
        onSakatsuSave: @escaping () -> Void
    ) -> some View {
        sheet(
            isPresented: .init(get: {
                shouldShowSheet
            }, set: { _ in
                onDismiss()
            })
        ) {
        } content: {
            NavigationStack {
                SakatsuInputScreen(
                    editMode: selectedSakatsu != nil ? .edit(sakatsu: selectedSakatsu!) : .new,
                    onSakatsuSave: onSakatsuSave
                )
            }
        }
    }

    func copyingSakatsuTextAlert(
        sakatsuText: String?,
        onDismiss: @escaping () -> Void
    ) -> some View {
        alert(
            L10n.copy,
            isPresented: .init(get: {
                sakatsuText != nil
            }, set: { _ in
                onDismiss()
            }),
            presenting: sakatsuText
        ) { _ in
        } message: { sakatsuText in
            Text(L10n.sakatsuTextCopied)
                .onAppear {
                    UIPasteboard.general.string = sakatsuText
                }
        }
    }
}

#if DEBUG
struct SakatsuListScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SakatsuListScreen(onSettingsButtonClick: {})
        }
    }
}
#endif
