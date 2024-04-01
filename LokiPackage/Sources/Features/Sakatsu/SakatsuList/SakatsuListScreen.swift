import SwiftUI
import SakatsuData
import LogCore
import UICore

// MARK: Actions

enum SakatsuListScreenAction {
    case onAddButtonClick
    case onSearchTextChange(searchText: String)
    case onSakatsuSave
    case onInputScreenCancelButtonClick
    case onInputScreenDismiss
    case onCopyingSakatsuTextAlertDismiss
    case onErrorAlertDismiss
    case onSettingsButtonClick
}

enum SakatsuListScreenAsyncAction {
    case task
}

// MARK: - View

package struct SakatsuListScreen: View {
    @StateObject private var viewModel: SakatsuListViewModel

    @Environment(\.colorScheme) private var colorScheme // swiftlint:disable:this attributes

    @State private var editMode: EditMode = .inactive

    package var body: some View {
        SakatsuListView(
            sakatsus: viewModel.uiState.filteredSakatsus,
            send: { action in
                viewModel.send(.view(action))
            }
        )
        .navigationTitle(String(localized: "Sakatsu list", bundle: .module))
        .searchable(
            text: .init(get: {
                viewModel.uiState.searchText
            }, set: { newValue in
                viewModel.send(.screen(.onSearchTextChange(searchText: newValue)))
            }),
            placement: .navigationBarDrawer(displayMode: .always)
        )
        .sakatsuListScreenToolbar(
            editMode: $editMode,
            colorScheme: colorScheme,
            sakatsusCount: viewModel.uiState.filteredSakatsus.count,
            onSettingsButtonClick: { viewModel.send(.screen(.onSettingsButtonClick)) },
            onAddButtonClick: { viewModel.send(.screen(.onAddButtonClick)) }
        )
        .sakatsuInputSheet(
            shouldShowSheet: viewModel.uiState.shouldShowInputScreen,
            selectedSakatsu: viewModel.uiState.selectedSakatsu,
            onSakatsuSave: { viewModel.send(.screen(.onSakatsuSave)) },
            onCancelButtonClick: { viewModel.send(.screen(.onInputScreenCancelButtonClick)) },
            onDismiss: { viewModel.send(.screen(.onInputScreenDismiss)) }
        )
        .copyingSakatsuTextAlert(
            sakatsuText: viewModel.uiState.sakatsuText,
            onDismiss: { viewModel.send(.screen(.onCopyingSakatsuTextAlertDismiss)) }
        )
        .errorAlert(
            error: viewModel.uiState.sakatsuListError,
            onDismiss: { viewModel.send(.screen(.onErrorAlertDismiss)) }
        )
        .task {
            await viewModel.sendAsync(.screen(.task))
        }
    }

    @MainActor
    package init(onSettingsButtonClick: @escaping () -> Void) {
        Logger.standard.debug("\(#function, privacy: .public)")

        self._viewModel = StateObject(wrappedValue: SakatsuListViewModel(
            onSettingsButtonClick: onSettingsButtonClick
        ))
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
