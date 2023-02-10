import SwiftUI

@MainActor
public protocol SakatsuRouterProtocol {
    associatedtype SettingsScreenType : View
    func settingsScreen() -> Self.SettingsScreenType
}

#if DEBUG
public final class SakatsuRouterMock {
    public static let shared = SakatsuRouterMock()
    
    private init() {}
}
    
extension SakatsuRouterMock: SakatsuRouterProtocol {
    public func settingsScreen() -> some View { EmptyView() }
}
#endif
