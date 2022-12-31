import SwiftUI

struct SakatsuSettingsScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("Foo")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
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
