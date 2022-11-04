import SwiftUI
import RecordsData

public struct RecordListScreen: View {
    @StateObject private var viewModel = RecordListViewModel()
    
    @State private var isShowingSheet = false
    
    public var body: some View {
        NavigationView {
            RecordListView(
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
                            RecordInputScreen(onSakatsuSave: {
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

struct RecordListScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecordListScreen()
    }
}

private struct RecordListView: View {
    let sakatsus: [Sakatsu]
    let onEditButtonClick: () -> Void
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(sakatsus) { sakatsu in
                RecordRowView(
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

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView(
            sakatsus: [Sakatsu.preview],
            onEditButtonClick: {},
            onDelete: { offsets in
                print("onDelete")
            }
        )
    }
}
