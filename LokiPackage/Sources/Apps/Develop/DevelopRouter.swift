import SwiftUI
import SakatsuFeature
import SettingsFeature
import LicensesFeature
import UICore

@MainActor
public final class DevelopRouter {
    public static let shared = DevelopRouter()
    
    @State private var shouldShowSettingsScreen = false
    @State private var shouldShowLicenseListScreen = false

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
        SakatsuListScreen(onSettingsButtonClick: { [weak self] in
            self?.shouldShowSettingsScreen = true
        })
        .sheet(isPresented: $shouldShowSettingsScreen) { [weak self] in
            NavigationStack {
                self?.makeSettingsScreen()
            }
        }
    }

    func makeSettingsScreen() -> some View {
        SettingsScreen(onLicensesButtonClick: { [weak self] in
            self?.shouldShowLicenseListScreen = true
        })
        .sheet(isPresented: $shouldShowLicenseListScreen) { [weak self] in
            self?.makeLicenseListScreen()
        }
    }

    func makeLicenseListScreen() -> some View {
        LicenseListScreen()
    }
}
