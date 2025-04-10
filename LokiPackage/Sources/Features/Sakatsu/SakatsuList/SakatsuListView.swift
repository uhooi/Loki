import SwiftUI
import SakatsuData

// MARK: Actions

enum SakatsuListViewAction {
    case onCopySakatsuTextButtonClick(sakatsuIndex: Int)
    case onEditButtonClick(sakatsuIndex: Int)
    case onDelete(_ offsets: IndexSet)
}

enum SakatsuListViewAsyncAction {
}

// MARK: - View

struct SakatsuListView: View {
    let sakatsus: [Sakatsu]
    let send: (SakatsuListViewAction) -> Void

    var body: some View {
        List {
            ForEach(sakatsus.indexed(), id: \.element.id) { sakatsuIndex, sakatsu in
                SakatsuRowView(
                    sakatsu: sakatsu,
                    send: { action in
                        switch action {
                        case .onCopySakatsuTextButtonClick:
                            send(.onCopySakatsuTextButtonClick(sakatsuIndex: sakatsuIndex))
                        case .onEditButtonClick:
                            send(.onEditButtonClick(sakatsuIndex: sakatsuIndex))
                        }
                    },
                )
            }
            .onDelete { offsets in
                send(.onDelete(offsets))
            }
        }
    }
}

#if DEBUG
// MARK: - Previews

#Preview {
    SakatsuListView(
        sakatsus: [.preview],
        send: { _ in },
    )
}
#endif
