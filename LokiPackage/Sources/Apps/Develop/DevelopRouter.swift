import SwiftUI
import SakatsuFeature
import SettingsFeature

@MainActor
public final class DevelopRouter {
    public static let shared = DevelopRouter()
    
    private init() {}
    
    public func firstScreen() -> some View {
        sakatsuListScreen()
    }
    
    private func sakatsuListScreen() -> some View {
        NavigationStack {
            SakatsuListScreen(settingsScreen: settingsScreen())
        }
    }
    
    private func settingsScreen() -> some View {
        NavigationStack {
            SettingsScreen()
        }
    }
}
