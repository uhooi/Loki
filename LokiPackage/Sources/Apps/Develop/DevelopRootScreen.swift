import SwiftUI
import SakatsuFeature
import SettingsFeature
import LicensesFeature
import DebugFeature

public struct DevelopRootScreen: View {
    @State private var isSettingsScreenPresented = false
    @State private var isLicenseListScreenPresented = false
    #if DEBUG
    @State private var isDebugScreenPresented = false
    #endif

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
            isSettingsScreenPresented = true
        })
        .navigationDestination(isPresented: $isSettingsScreenPresented) {
            makeSettingsScreen()
        }
    }

    #if DEBUG
    @MainActor
    func makeSettingsScreen() -> some View {
        SettingsScreen(onLicensesButtonClick: {
            isLicenseListScreenPresented = true
        }, onDebugButtonClick: {
            isDebugScreenPresented = true
        })
        .sheet(isPresented: $isLicenseListScreenPresented) {
        } content: {
            makeLicenseListScreen()
        }
        .fullScreenCover(isPresented: $isDebugScreenPresented) {
        } content: {
            NavigationStack {
                makeDebugScreen()
            }
        }
    }
    #else
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
    #endif

    func makeLicenseListScreen() -> some View {
        LicenseListScreen()
    }

    #if DEBUG
    func makeDebugScreen() -> some View {
        DebugScreen()
    }
    #endif
}
