import SwiftUI
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
        .debugScreenToolbar(
            onCloseButtonClick: {
                dismiss()
            }
        )
    }

    package init() {
        Logger.standard.debug("\(#function, privacy: .public)")
    }
}

// MARK: - Privates

private extension View {
    func debugScreenToolbar(
        onCloseButtonClick: @escaping () -> Void
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .topBarLeading) {
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
    NavigationStack {
        DebugScreen()
    }
}
#endif
