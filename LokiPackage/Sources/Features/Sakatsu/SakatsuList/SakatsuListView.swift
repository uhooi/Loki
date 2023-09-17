import SwiftUI
import SakatsuData

struct SakatsuListView: View {
    let sakatsus: [Sakatsu]

    let onCopySakatsuTextButtonClick: (_ sakatsuIndex: Int) -> Void
    let onEditButtonClick: (_ sakatsuIndex: Int) -> Void
    let onDelete: (_ offsets: IndexSet) -> Void

    var body: some View {
        List {
            ForEach(sakatsus.indexed(), id: \.element.id) { sakatsuIndex, sakatsu in
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

#Preview {
    SakatsuListView(
        sakatsus: [.preview],
        onCopySakatsuTextButtonClick: { _ in },
        onEditButtonClick: { _ in },
        onDelete: { _ in }
    )
}
