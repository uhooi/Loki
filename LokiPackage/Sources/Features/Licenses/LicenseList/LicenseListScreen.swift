import SwiftUI

public struct LicenseListScreen: View {
    public var body: some View {
        List(LicensesPlugin.licenses) { license in
            NavigationLink(
                license.name,
                destination: LicenseDetailScreen(license: license)
            )
        }
        .navigationTitle(L10n.licenses)
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
