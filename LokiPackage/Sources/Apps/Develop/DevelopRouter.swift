import SwiftUI
import SakatsuFeature
import SettingsFeature
import LicensesFeature
import UICore

@MainActor
public final class DevelopRouter {
    public static let shared = DevelopRouter()
    
    private var shouldShowSettingsScreen = false
    private var shouldShowLicenseListScreen = false

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
        .sheet(
            isPresented: .constant(shouldShowSettingsScreen),
            onDismiss: { [weak self] in
                self?.shouldShowSettingsScreen = false
            }
        ) { [weak self] in
            NavigationStack {
                self?.makeSettingsScreen()
            }
        }
    }

    func makeSettingsScreen() -> some View {
        SettingsScreen(onLicensesButtonClick: { [weak self] in
            self?.shouldShowLicenseListScreen = true
        })
        .sheet(
            isPresented: .constant(shouldShowLicenseListScreen),
            onDismiss: { [weak self] in
                self?.shouldShowLicenseListScreen = false
            }
        ) { [weak self] in
            self?.makeLicenseListScreen()
        }
    }

    func makeLicenseListScreen() -> some View {
        LicenseListScreen()
    }
}
