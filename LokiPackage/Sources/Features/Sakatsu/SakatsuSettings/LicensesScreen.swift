import SwiftUI
import LicenseList

struct LicensesScreen: View {
    var body: some View {
        LicenseListView()
            .navigationTitle("Licenses")
    }
}

struct LicensesScreen_Previews: PreviewProvider {
    static var previews: some View {
        LicensesScreen()
    }
}
