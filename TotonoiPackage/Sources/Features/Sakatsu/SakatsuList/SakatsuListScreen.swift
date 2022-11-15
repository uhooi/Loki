import SwiftUI
import SakatsuData

public struct SakatsuListScreen: View {
    @StateObject private var viewModel: SakatsuListViewModel<SakatsuUserDefaultsClient>
    
    @State private var isShowingInputSheet = false
    
    public var body: some View {
        NavigationView {
            SakatsuListView(
                sakatsus: viewModel.uiState.sakatsus,
                onEditButtonClick: { sakatsuIndex in
                    viewModel.onEditButtonClick(sakatsuIndex: sakatsuIndex)
                    isShowingInputSheet = true
                }, onCopySakatsuTextButtonClick: { sakatsuIndex in
                    viewModel.onCopySakatsuTextButtonClick(sakatsuIndex: sakatsuIndex)
                }, onDelete: { offsets in
                    viewModel.onDelete(at: offsets)
                }
            )
            .navigationTitle("サ活一覧")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.onAddButtonClick()
                        isShowingInputSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isShowingInputSheet) {
                        NavigationView {
                            SakatsuInputScreen(
                                sakatsu: viewModel.uiState.selectedSakatsu,
                                onSakatsuSave: {
                                    isShowingInputSheet = false
                                    viewModel.onSakatsuSave()
                                }
                            )
                        }
                    }
                }
            }
            .alert(
                "コピー",
                isPresented: .constant(viewModel.uiState.sakatsuText != nil),
                presenting: viewModel.uiState.sakatsuText
            ) { _ in
                Button("OK") {
                    viewModel.onCopyingSakatsuTextAlertDismiss()
                }
            } message: { sakatsuText in
                Text("サ活のテキストをコピーしました。")
                    .onAppear {
                        UIPasteboard.general.string = sakatsuText
                    }
            }
            .alert(
                isPresented: .constant(viewModel.uiState.sakatsuListError != nil),
                error: viewModel.uiState.sakatsuListError
            ) { _ in
                Button("OK") {
                    viewModel.onErrorAlertDismiss()
                }
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
    let onEditButtonClick: (Int) -> Void
    let onCopySakatsuTextButtonClick: (Int) -> Void
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(sakatsus.indexed(), id: \.index) { sakatsuIndex, sakatsu in
                SakatsuRowView(
                    sakatsu: sakatsu,
                    onEditButtonClick: {
                        onEditButtonClick(sakatsuIndex)
                    }, onCopySakatsuTextButtonClick: {
                        onCopySakatsuTextButtonClick(sakatsuIndex)
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
            onEditButtonClick: { _ in },
            onCopySakatsuTextButtonClick: { _ in },
            onDelete: { _ in }
        )
    }
}
