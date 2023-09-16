import SwiftUI
import SakatsuData

struct SakatsuListView: View {
    let sakatsus: [Sakatsu]

    let onCopySakatsuTextButtonClick: (_ sakatsuIndex: Int) -> Void
    let onEditButtonClick: (_ sakatsuIndex: Int) -> Void
    let onDelete: (_ offsets: IndexSet) -> Void

    var body: some View {
        List {
            ForEach(sakatsus.indexed(), id: \.element) { sakatsuIndex, sakatsu in
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

// MARK: - Previews

#if DEBUG
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
#endif
