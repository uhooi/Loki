import SwiftUI
import UICore
import SakatsuData

public struct SakatsuListScreen: View {
    @StateObject private var viewModel: SakatsuListViewModel<SakatsuUserDefaultsClient>
    
    public var body: some View {
        NavigationStack {
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
            .navigationTitle(String(localized: "Sakatsu list", bundle: .module))
            .overlay(alignment: .bottomTrailing) {
                ActionButton(
                    systemName: "plus",
                    action: { viewModel.onAddButtonClick() }
                )
                .padding(16)
            }
            .sakatsuListScreenToolbar(
                onSettingsButtonClick: { viewModel.onSettingsButtonClick() }
            )
            .sakatsuInputSheet(
                shouldShowSheet: viewModel.uiState.shouldShowInputSheet,
                selectedSakatsu: viewModel.uiState.selectedSakatsu,
                onDismiss: { viewModel.onInputSheetDismiss() },
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
    }
    
    public init() {
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
    
    func sakatsuInputSheet(
        shouldShowSheet: Bool,
        selectedSakatsu: Sakatsu?,
        onDismiss: @escaping () -> Void,
        onSakatsuSave: @escaping () -> Void
    ) -> some View {
        sheet(isPresented: .init(get: {
            shouldShowSheet
        }, set: { _ in
            onDismiss()
        })) {
            SakatsuInputScreen(
                sakatsu: selectedSakatsu,
                onSakatsuSave: onSakatsuSave
            )
        }
    }
    
    func copyingSakatsuTextAlert(
        sakatsuText: String?,
        onDismiss: @escaping () -> Void
    ) -> some View {
        alert(
            String(localized: "Copy", bundle: .module),
            isPresented: .init(get: {
                sakatsuText != nil
            }, set: { _ in
                onDismiss()
            }),
            presenting: sakatsuText
        ) { _ in
        } message: { sakatsuText in
            Text("Sakatsu text copied.", bundle: .module)
                .onAppear {
                    UIPasteboard.general.string = sakatsuText
                }
        }
    }
}

#if DEBUG
struct SakatsuListScreen_Previews: PreviewProvider {
    static var previews: some View {
        SakatsuListScreen()
    }
}
#endif
