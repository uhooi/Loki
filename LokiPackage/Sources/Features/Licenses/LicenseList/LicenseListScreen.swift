import SwiftUI
import LogCore

package struct LicenseListScreen: View {
    @State private var selectedLicense: LicensesPlugin.License?

    @Environment(\.dismiss) private var dismiss // swiftlint:disable:this attributes

    package var body: some View {
        NavigationSplitView {
            List(LicensesPlugin.licenses, selection: $selectedLicense) { license in
                NavigationLink(license.name, value: license)
            }
            .navigationTitle(String(localized: "Licenses", bundle: .module))
            .licenseListScreenToolbar(onCloseButtonClick: { dismiss() })
        } detail: {
            if let selectedLicense {
                LicenseDetailScreen(license: selectedLicense)
            } else {
                Text("Select a license", bundle: .module)
                    .foregroundStyle(.secondary)
            }
        }
    }

    package init() {
        let message = "\(#file) \(#function)"
        Logger.standard.debug("\(message, privacy: .public)")
    }
}

// MARK: - Privates

private extension View {
    func licenseListScreenToolbar(
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

// MARK: - Previews

#if DEBUG
#Preview {
    LicenseListScreen()
}
#endif
