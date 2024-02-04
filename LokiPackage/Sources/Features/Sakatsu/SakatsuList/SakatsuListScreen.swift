import SwiftUI
import SakatsuData
import LogCore
import UICore

package struct SakatsuListScreen: View {
    private let onSettingsButtonClick: () -> Void
    @StateObject private var viewModel: SakatsuListViewModel
    @Environment(\.colorScheme) private var colorScheme // swiftlint:disable:this attributes
    @State private var editMode: EditMode = .inactive

    package var body: some View {
        SakatsuListView(
            sakatsus: viewModel.uiState.filteredSakatsus,
            onCopySakatsuTextButtonClick: { sakatsuIndex in
                viewModel.send(.onCopySakatsuTextButtonClick(sakatsuIndex: sakatsuIndex))
            }, onEditButtonClick: { sakatsuIndex in
                viewModel.send(.onEditButtonClick(sakatsuIndex: sakatsuIndex))
            }, onDelete: { offsets in
                viewModel.send(.onDelete(offsets: offsets))
            }
        )
        .navigationTitle(String(localized: "Sakatsu list", bundle: .module))
        .searchable(
            text: .init(get: {
                viewModel.uiState.searchText
            }, set: { newValue in
                viewModel.send(.onSearchTextChange(searchText: newValue))
            }),
            placement: .navigationBarDrawer(displayMode: .always)
        )
        .sakatsuListScreenToolbar(
            editMode: $editMode,
            colorScheme: colorScheme,
            sakatsusCount: viewModel.uiState.filteredSakatsus.count,
            onSettingsButtonClick: { onSettingsButtonClick() },
            onAddButtonClick: { viewModel.send(.onAddButtonClick) }
        )
        .sakatsuInputSheet(
            shouldShowSheet: viewModel.uiState.shouldShowInputScreen,
            selectedSakatsu: viewModel.uiState.selectedSakatsu,
            onSakatsuSave: { viewModel.send(.onSakatsuSave) },
            onCancelButtonClick: { viewModel.send(.onInputScreenCancelButtonClick) },
            onDismiss: { viewModel.send(.onInputScreenDismiss) }
        )
        .copyingSakatsuTextAlert(
            sakatsuText: viewModel.uiState.sakatsuText,
            onDismiss: { viewModel.send(.onCopyingSakatsuTextAlertDismiss) }
        )
        .errorAlert(
            error: viewModel.uiState.sakatsuListError,
            onDismiss: { viewModel.send(.onErrorAlertDismiss) }
        )
    }

    @MainActor
    package init(onSettingsButtonClick: @escaping () -> Void) {
        let message = "\(#file) \(#function)"
        Logger.standard.debug("\(message, privacy: .public)")
        self.onSettingsButtonClick = onSettingsButtonClick
        self._viewModel = StateObject(wrappedValue: SakatsuListViewModel())
    }
}

// MARK: - Privates

private extension View {
    func sakatsuListScreenToolbar(
        editMode: Binding<EditMode>,
        colorScheme: ColorScheme,
        sakatsusCount: Int,
        onSettingsButtonClick: @escaping () -> Void,
        onAddButtonClick: @escaping () -> Void
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
                    .bold(editMode.wrappedValue.isEditing)
            }
            ToolbarItem(placement: .topBarLeading) {
                Button(action: onSettingsButtonClick) {
                    Image(systemName: colorScheme != .dark ? "gearshape" : "gearshape.fill")
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: onAddButtonClick) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        Text("New Sakatsu", bundle: .module)
                    }
                    .bold()
                }
            }
            ToolbarItem(placement: .status) {
                Text("\(sakatsusCount) Sakatsu(s)", bundle: .module)
                    .font(.caption)
            }
        }
        .environment(\.editMode, editMode)
    }

    @MainActor
    func sakatsuInputSheet(
        shouldShowSheet: Bool,
        selectedSakatsu: Sakatsu?,
        onSakatsuSave: @escaping () -> Void,
        onCancelButtonClick: @escaping () -> Void,
        onDismiss: @escaping () -> Void
    ) -> some View {
        sheet(
            isPresented: .init(get: {
                shouldShowSheet
            }, set: { _ in
            })
        ) {
            onDismiss()
        } content: {
            NavigationStack {
                SakatsuInputScreen(
                    sakatsuEditMode: selectedSakatsu != nil ? .edit(sakatsu: selectedSakatsu!) : .new,
                    onSakatsuSave: onSakatsuSave,
                    onCancelButtonClick: onCancelButtonClick
                )
            }
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

// MARK: - Previews

#if DEBUG
#Preview {
    NavigationStack {
        SakatsuListScreen(onSettingsButtonClick: {})
    }
}
#endif
