import SwiftUI
import SakatsuFeature
import SettingsFeature
import LicensesFeature

public struct DevelopRootScreen: View {
    @State private var shouldShowSettingsScreen = false
    @State private var shouldShowLicenseListScreen = false

    public var body: some View {
        NavigationStack {
            makeSakatsuListScreen()
        }
    }

    public init() {}
}

// MARK: - Screen factory

private extension DevelopRootScreen {
    @MainActor
    func makeSakatsuListScreen() -> some View {
        SakatsuListScreen(onSettingsButtonClick: {
            shouldShowSettingsScreen = true
        })
        .sheet(isPresented: $shouldShowSettingsScreen) {
            NavigationStack {
                makeSettingsScreen()
            }
        }
    }

    @MainActor
    func makeSettingsScreen() -> some View {
        SettingsScreen(onLicensesButtonClick: {
            shouldShowLicenseListScreen = true
        })
        .sheet(isPresented: $shouldShowLicenseListScreen) {
            makeLicenseListScreen()
        }
    }

    func makeLicenseListScreen() -> some View {
        LicenseListScreen()
    }
}
