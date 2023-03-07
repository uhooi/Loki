import SwiftUI
import SakatsuFeature
import SettingsFeature
import LicensesFeature
import UICore

@MainActor
public final class DevelopRouter {
    public static let shared = DevelopRouter()

    private init() {}

    public func firstScreen() -> some View {
        NavigationStack {
            makeSakatsuListScreen()
        }
    }
}

// MARK: - Screen factory

private extension DevelopRouter {
    func makeSakatsuListScreen() -> some View {
        SakatsuListScreen(onSettingsButtonClick: { sakatsuListScreen in
            sakatsuListScreen
                .settingsSheet(settingsScreen: NavigationStack { self.makeSettingsScreen() })
        })
    }

    func makeSettingsScreen() -> some View {
        SettingsScreen(router: Self.shared)
    }
    
    func makeLicenseListScreen() -> some View {
        LicenseListScreen()
    }
}

private extension View {
    func settingsSheet(settingsScreen: some View) -> some View {
        sheet(isPresented: .constant(true)) {
            settingsScreen
        }
    }
}
