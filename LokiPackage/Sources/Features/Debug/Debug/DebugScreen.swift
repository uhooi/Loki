package import SwiftUI
import os
import LogdogUI
import LogCore

package struct DebugScreen: View {
    @Environment(\.dismiss) private var dismiss // swiftlint:disable:this attributes

    package var body: some View {
        Form {
            Section {
                NavigationLink(String(localized: "Log", bundle: .module)) {
                    LogdogScreen()
                        .navigationTitle(String(localized: "Log", bundle: .module))
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .navigationTitle(String(localized: "Debug", bundle: .module))
        .toolbar { toolbarContent(onCloseButtonClick: { dismiss() }) }
    }

    package init() {
        Logger.standard.debug("\(#function, privacy: .public)")
    }
}

// MARK: - Privates

private extension DebugScreen {
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
    NavigationStack {
        DebugScreen()
    }
}
#endif
