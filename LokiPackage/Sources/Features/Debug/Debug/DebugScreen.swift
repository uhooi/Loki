import SwiftUI
import LogCore

package struct DebugScreen: View {
    package var body: some View {
        Form {
            Section {
                NavigationLink(String(localized: "Log", bundle: .module)) {
                    LogScreen()
                }
            }
        }
        .navigationTitle(String(localized: "Debug", bundle: .module))
    }

    package init() {
        Logger.standard.debug("\(#function, privacy: .public)")
    }
}
