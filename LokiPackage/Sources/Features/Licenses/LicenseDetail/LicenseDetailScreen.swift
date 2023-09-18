import SwiftUI
import LogCore

struct LicenseDetailScreen: View {
    let license: LicensesPlugin.License

    var body: some View {
        Group {
            if let licenseText = license.licenseText {
                ScrollView {
                    Text(licenseText)
                        .padding()
                }
            } else {
                Text("No license found", bundle: .module)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle(license.name)
    }

    init(license: LicensesPlugin.License) {
        let message = "\(#file) \(#function)"
        Logger.standard.debug("\(message, privacy: .public)")
        self.license = license
    }
}

// MARK: - Previews

#if DEBUG
#Preview {
    LicenseDetailScreen(license: .init(id: "loki", name: "Loki", licenseText: nil))
}
#endif
