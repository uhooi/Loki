import SwiftUI
import SakatsuData
import LogCore
import UICore

public struct SakatsuListScreen: View {
    private let onSettingsButtonClick: () -> Void
    @StateObject private var viewModel: SakatsuListViewModel
    
    @Environment(\.colorScheme) private var colorScheme

    public var body: some View {
        SakatsuListView(
            sakatsus: viewModel.uiState.sakatsus,
            onCopySakatsuTextButtonClick: { sakatsuIndex in
                viewModel.send(.onCopySakatsuTextButtonClick(sakatsuIndex: sakatsuIndex))
            }, onEditButtonClick: { sakatsuIndex in
                viewModel.send(.onEditButtonClick(sakatsuIndex: sakatsuIndex))
            }, onDelete: { offsets in
                viewModel.send(.onDelete(offsets: offsets))
            }
        )
        .navigationTitle(L10n.sakatsuList)
        .overlay(alignment: .bottomTrailing) {
            FAB(
                systemName: "plus",
                action: { viewModel.send(.onAddButtonClick) }
            )
            .padding(16)
        }
        .sakatsuListScreenToolbar(
            colorScheme: colorScheme,
            onSettingsButtonClick: { onSettingsButtonClick() }
        )
        .sakatsuInputSheet(
            shouldShowSheet: viewModel.uiState.shouldShowInputScreen,
            selectedSakatsu: viewModel.uiState.selectedSakatsu,
            onDismiss: { viewModel.send(.onInputScreenDismiss) },
            onSakatsuSave: { viewModel.send(.onSakatsuSave) }
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
    public init(onSettingsButtonClick: @escaping () -> Void) {
        let message = "\(#file) \(#function)"
        Logger.standard.debug("\(message, privacy: .public)")
        self.onSettingsButtonClick = onSettingsButtonClick
        self._viewModel = StateObject(wrappedValue: SakatsuListViewModel())
    }
}

// MARK: - Privates

private extension View {
    func sakatsuListScreenToolbar(
        colorScheme: ColorScheme,
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
                    Image(systemName: colorScheme != .dark ? "gearshape" : "gearshape.fill")
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

// MARK: - Previews

#Preview {
    NavigationStack {
        SakatsuListScreen(onSettingsButtonClick: {})
    }
}
