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
                onEditButtonClick: {
                    viewModel.onEditButtonClick()
                }, onOutputSakatsuTextButtonClick: { sakatsuIndex in
                    viewModel.onOutputSakatsuTextButtonClick(sakatsuIndex: sakatsuIndex)
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
    let onEditButtonClick: () -> Void
    let onOutputSakatsuTextButtonClick: (Int) -> Void
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(sakatsus.indexed(), id: \.index) { sakatsuIndex, sakatsu in
                SakatsuRowView(
                    sakatsu: sakatsu,
                    onEditButtonClick: {
                        onEditButtonClick()
                    }, onOutputSakatsuTextButtonClick: {
                        onOutputSakatsuTextButtonClick(sakatsuIndex)
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
            onEditButtonClick: {},
            onOutputSakatsuTextButtonClick: { _ in },
            onDelete: { _ in }
        )
    }
}
