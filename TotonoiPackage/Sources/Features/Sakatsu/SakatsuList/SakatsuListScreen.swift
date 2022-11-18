import SwiftUI
import SakatsuData

public struct SakatsuListScreen: View {
    @StateObject private var viewModel: SakatsuListViewModel<SakatsuUserDefaultsClient>
    
    public var body: some View {
        NavigationView {
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
            .navigationTitle("サ活一覧")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    EditButton()
                    Button {
                        viewModel.onAddButtonClick()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: .init(get: {
                viewModel.uiState.shouldShowInputSheet
            }, set: { _ in
                viewModel.onInputSheetDismiss()
            })) {
                NavigationView {
                    SakatsuInputScreen(
                        sakatsu: viewModel.uiState.selectedSakatsu,
                        onSakatsuSave: {
                            viewModel.onSakatsuSave()
                        }
                    )
                }
            }
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
    func copyingSakatsuTextAlert(
        sakatsuText: String?,
        onDismiss: @escaping () -> Void
    ) -> some View {
        alert(
            "コピー",
            isPresented: .init(get: {
                sakatsuText != nil
            }, set: { _ in
                onDismiss()
            }),
            presenting: sakatsuText
        ) { _ in
        } message: { sakatsuText in
            Text("サ活のテキストをコピーしました。")
                .onAppear {
                    UIPasteboard.general.string = sakatsuText
                }
        }
    }
}

struct SakatsuListScreen_Previews: PreviewProvider {
    static var previews: some View {
        SakatsuListScreen()
    }
}
