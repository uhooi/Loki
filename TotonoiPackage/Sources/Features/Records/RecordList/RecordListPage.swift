import SwiftUI
import RecordsData

public struct RecordListPage: View {
    @StateObject private var viewModel = RecordListViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            RecordListView(sakatsus: viewModel.uiState.sakatsus)
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
}

struct RecordListPage_Previews: PreviewProvider {
    static var previews: some View {
        RecordListPage()
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
