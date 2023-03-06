import SwiftUI

public struct LicensesScreen: View {
    @State private var selectedLicense: LicensesPlugin.License?
    
    public var body: some View {
        List {
            ForEach(LicensesPlugin.licenses) { license in
                Button(license.name) {
                    selectedLicense = license
                }
            }
        }
        .sheet(item: $selectedLicense) { license in
            NavigationStack {
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
        .navigationTitle(L10n.licenses)
    }
    
    public init() {}
}

#if DEBUG
struct LicensesScreen_Previews: PreviewProvider {
    static var previews: some View {
        LicensesScreen()
    }
}
#endif
