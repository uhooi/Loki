import SwiftUI
import RecordsData

public struct RecordListScreen: View {
    @StateObject private var viewModel = RecordListViewModel()
    
    public var body: some View {
        NavigationView {
            RecordListView(sakatsus: viewModel.uiState.sakatsus)
                .navigationTitle("サ活一覧")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink {
                            RecordInputScreen()
                        } label: {
                            Image(systemName: "plus")
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
    var sakatsus: [Sakatsu]
    
    var body: some View {
        List(sakatsus) { sakatsu in
            RecordRowView(sakatsu: sakatsu)
                .padding(.vertical)
        }
    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView(sakatsus: [Sakatsu.preview])
    }
}
