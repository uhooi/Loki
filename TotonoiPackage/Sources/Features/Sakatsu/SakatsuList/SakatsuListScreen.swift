import SwiftUI
import SakatsuData

public struct SakatsuListScreen: View {
    @StateObject private var viewModel = SakatsuListViewModel()
    
    @State private var isShowingInputSheet = false
    @State private var isPresentingCopyingSakatsuTextAlert = false
    
    public var body: some View {
        NavigationView {
            SakatsuListView(
                sakatsus: viewModel.uiState.sakatsus,
                onEditButtonClick: { sakatsuIndex in
                    viewModel.onEditButtonClick(sakatsuIndex: sakatsuIndex)
                }, onCopySakatsuTextButtonClick: { sakatsuIndex in
                    viewModel.onCopySakatsuTextButtonClick(sakatsuIndex: sakatsuIndex)
                }, onDelete: { offsets in
                    try? viewModel.onDelete(at: offsets) // TODO: Error handling
                }
            )
            .navigationTitle("サ活一覧")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingInputSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isShowingInputSheet) {
                        NavigationView {
                            SakatsuInputScreen(onSakatsuSave: {
                                isShowingInputSheet = false
                                viewModel.onSakatsuSave()
                            })
                        }
                    }
                }
            }
            .onChange(of: viewModel.uiState.shouldPresentCopyingSakatsuTextAlert) { _ in
                guard viewModel.uiState.shouldPresentCopyingSakatsuTextAlert else {
                    return
                }
                UIPasteboard.general.string = viewModel.uiState.sakatsuText
                isPresentingCopyingSakatsuTextAlert = true
                viewModel.onSakatsuTextCopy()
            }
            .alert("コピー", isPresented: $isPresentingCopyingSakatsuTextAlert) {
            } message: {
                Text("サ活用のテキストをコピーしました。")
            }
        }
    }
    
    public init() {}
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