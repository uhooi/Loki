import SwiftUI
import SakatsuData

struct SakatsuListView: View {
    let sakatsus: [Sakatsu]
    
    let onCopySakatsuTextButtonClick: (Int) -> Void
    let onEditButtonClick: (Int) -> Void
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(sakatsus.indexed(), id: \.index) { sakatsuIndex, sakatsu in
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
