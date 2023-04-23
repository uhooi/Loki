import SwiftUI

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
                Text(L10n.noLicenseFound)
            }
        }
        .navigationTitle(license.name)
    }
}

// MARK: - Previews

#if DEBUG
struct LicenseDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        LicenseDetailScreen(license: .init(id: "loki", name: "Loki", licenseText: nil))
    }
}
#endif
