package import SwiftUI
import os
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
            .toolbar { toolbarContent(onCloseButtonClick: { dismiss() }) }
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
        Logger.standard.debug("\(#function, privacy: .public)")
    }
}

// MARK: - Privates

private extension LicenseListScreen {
    @ToolbarContentBuilder
    func toolbarContent(
        onCloseButtonClick: @escaping () -> Void,
    ) -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(role: .cancel) {
                onCloseButtonClick()
            } label: {
                Image(systemName: "xmark")
            }
            .accessibilityLabel(String(localized: "Close", bundle: .module))
        }
    }
}

#if DEBUG
// MARK: - Previews

#Preview {
    LicenseListScreen()
}
#endif
