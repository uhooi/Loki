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
                ToolbarItem(placement: .primaryAction) {
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
            .alert(
                "コピー",
                isPresented: .init(get: {
                    viewModel.uiState.sakatsuText != nil
                }, set: { _ in
                    viewModel.onCopyingSakatsuTextAlertDismiss()
                }),
                presenting: viewModel.uiState.sakatsuText
            ) { _ in
            } message: { sakatsuText in
                Text("サ活のテキストをコピーしました。")
                    .onAppear {
                        UIPasteboard.general.string = sakatsuText
                    }
            }
            .alert(
                isPresented: .init(get: {
                    viewModel.uiState.sakatsuListError != nil
                }, set: { _ in
                    viewModel.onErrorAlertDismiss()
                }),
                error: viewModel.uiState.sakatsuListError
            ) { _ in
            } message: { sakatsuListError in
                Text((sakatsuListError.failureReason ?? "") + (sakatsuListError.recoverySuggestion ?? ""))
            }
        }
    }
    
    public init() {
        self._viewModel = StateObject(wrappedValue: SakatsuListViewModel())
    }
}

struct SakatsuListScreen_Previews: PreviewProvider {
    static var previews: some View {
        SakatsuListScreen()
    }
}

private struct SakatsuListView: View {
    let sakatsus: [Sakatsu]
    
    let onCopySakatsuTextButtonClick: (Int) -> Void
    let onEditButtonClick: (Int) -> Void
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(sakatsus.indexed(), id: \.index) { sakatsuIndex, sakatsu in
                SakatsuRowView(
                    sakatsu: sakatsu,
                    onCopySakatsuTextButtonClick: {
                        onCopySakatsuTextButtonClick(sakatsuIndex)
                    }, onEditButtonClick: {
                        onEditButtonClick(sakatsuIndex)
                    }
                )
            }
            .onDelete { offsets in
                onDelete(offsets)
            }
        }
    }
}

struct SakatsuListView_Previews: PreviewProvider {
    static var previews: some View {
        SakatsuListView(
            sakatsus: [.preview],
            onCopySakatsuTextButtonClick: { _ in },
            onEditButtonClick: { _ in },
            onDelete: { _ in }
        )
    }
}
