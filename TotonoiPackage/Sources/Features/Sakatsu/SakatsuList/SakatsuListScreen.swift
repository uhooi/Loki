import SwiftUI
import SakatsuData

public struct SakatsuListScreen: View {
    @StateObject private var viewModel = SakatsuListViewModel()
    
    @State private var isShowingSheet = false
    
    public var body: some View {
        NavigationView {
            SakatsuListView(
                sakatsus: viewModel.uiState.sakatsus,
                onEditButtonClick: {
                    viewModel.onEditButtonClick()
                }, onDelete: { offsets in
                    Task {
                        try? await viewModel.onDelete(at: offsets) // TODO: Error handling
                    }
                }
            )
            .navigationTitle("サ活一覧")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isShowingSheet) {
                        NavigationView {
                            SakatsuInputScreen(onSakatsuSave: {
                                isShowingSheet = false
                                Task {
                                    await viewModel.onSakatsuSave()
                                }
                                })
                        }
                    }
                }
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
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(sakatsus) { sakatsu in
                SakatsuRowView(
                    sakatsu: sakatsu,
                    onEditButtonClick: {
                        onEditButtonClick()
                    })
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
            onDelete: { _ in }
        )
    }
}
