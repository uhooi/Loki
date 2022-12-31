import SwiftUI

struct SakatsuSettingsScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            SakatsuSettingsView()
                .navigationTitle(String(localized: "Settings", bundle: .module))
                .sakatsuSettingsScreenToolbar(onCloseButtonClick: { dismiss() })
        }
    }
}

private extension View {
    func sakatsuSettingsScreenToolbar(
        onCloseButtonClick: @escaping () -> Void
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    onCloseButtonClick()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

#if DEBUG
struct SakatsuSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SakatsuSettingsScreen()
    }
}
#endif
