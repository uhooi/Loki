import SwiftUI

struct SakatsuSettingsScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Version", bundle: .module)
                        Spacer()
                        Text("\(Bundle.main.version) (\(Bundle.main.build))")
                    }
                } footer: {
                    Text("© 2023 THE Uhooi")
                }
            }
            .navigationTitle(String(localized: "Settings", bundle: .module))
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
