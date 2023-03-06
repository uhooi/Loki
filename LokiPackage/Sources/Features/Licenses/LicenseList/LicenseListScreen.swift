import SwiftUI

public struct LicenseListScreen: View {
    @State private var selectedLicense: LicensesPlugin.License?
    
    public var body: some View {
        List {
            ForEach(LicensesPlugin.licenses) { license in
                Button(license.name) {
                    selectedLicense = license
                }
            }
        }
        .navigationTitle(L10n.licenses)
        .sheet(item: $selectedLicense) { license in
            NavigationStack {
                LicenseDetailScreen(license: license)
            }
        }
    }
    
    public init() {}
}

#if DEBUG
struct LicenseListScreen_Previews: PreviewProvider {
    static var previews: some View {
        LicenseListScreen()
    }
}
#endif
