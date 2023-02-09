import SwiftUI
import SakatsuFeature
import SettingsFeature
import UICore

@MainActor
public final class ProductionRouter {
    public static let shared = ProductionRouter()
    
    private init() {}
    
    public func firstScreen() -> some View {
        NavigationStack {
            makeSakatsuListScreen()
        }
    }
}

extension ProductionRouter: SakatsuRouterProtocol {
    public func settingsScreen() -> some View {
        NavigationStack {
            makeSettingsScreen()
        }
    }
}

// MARK: - Screen factory

private extension ProductionRouter {
    func makeSakatsuListScreen() -> some View {
        SakatsuListScreen(router: Self.shared)
    }
    
    func makeSettingsScreen() -> some View {
        SettingsScreen()
    }
}
