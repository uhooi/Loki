import SwiftUI
import SakatsuFeature
import SettingsFeature
import LicensesFeature

public struct ProductionRootScreen: View {
    @State private var isSettingsScreenPresented = false
    @State private var isLicenseListScreenPresented = false

    public var body: some View {
        NavigationStack {
            makeSakatsuListScreen()
        }
    }

    public init() {}
}

// MARK: - Screen factory

private extension ProductionRootScreen {
    @MainActor
    func makeSakatsuListScreen() -> some View {
        SakatsuListScreen(onSettingsButtonClick: {
            isSettingsScreenPresented = true
        })
        .sheet(isPresented: $isSettingsScreenPresented) {
        } content: {
            NavigationStack {
                makeSettingsScreen()
            }
        }
    }

    @MainActor
    func makeSettingsScreen() -> some View {
        SettingsScreen(onLicensesButtonClick: {
            isLicenseListScreenPresented = true
        })
        .sheet(isPresented: $isLicenseListScreenPresented) {
        } content: {
            makeLicenseListScreen()
        }
    }

    func makeLicenseListScreen() -> some View {
        LicenseListScreen()
    }
}
