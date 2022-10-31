import SwiftUI
import RecordsData

public struct RecordListPage: View {
    @StateObject private var viewModel = RecordListViewModel()
    
    public init() {}
    
    public var body: some View {
        RecordListView(sakatsus: viewModel.uiState.sakatsus)
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

struct RecordsListView: PreviewProvider {
    static var previews: some View {
        RecordListView(sakatsus: [Sakatsu.preview])
    }
}
