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
        .settingsSheet(
            shouldShowSheet: shouldShowSettingsScreen,
            settingsScreen: NavigationStack { makeSettingsScreen() },
            onDismiss: { [weak self] in
                self?.shouldShowSettingsScreen = false
            }
        )
    }

    func makeSettingsScreen() -> some View {
        SettingsScreen(onLicensesButtonClick: { [weak self] in
            self?.shouldShowLicenseListScreen = true
        })
        .licenseListSheet(
            shouldShowSheet: shouldShowLicenseListScreen,
            licenseListScreen: makeLicenseListScreen(),
            onDismiss: { [weak self] in
                self?.shouldShowLicenseListScreen = false
            }
        )
    }
    
    func makeLicenseListScreen() -> some View {
        LicenseListScreen()
    }
}

private extension View {
    func settingsSheet(
        shouldShowSheet: Bool,
        settingsScreen: some View,
        onDismiss: @escaping () -> Void
    ) -> some View {
        sheet(
            isPresented: .constant(shouldShowSheet),
            onDismiss: { onDismiss() },
            content: { settingsScreen }
        )
    }

    func licenseListSheet(
        shouldShowSheet: Bool,
        licenseListScreen: some View,
        onDismiss: @escaping () -> Void
    ) -> some View {
        sheet(
            isPresented: .constant(shouldShowSheet),
            onDismiss: { onDismiss() },
            content: { licenseListScreen }
        )
    }
}
