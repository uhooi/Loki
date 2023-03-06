import SwiftUI

@MainActor
public protocol SettingsRouterProtocol {
    associatedtype LicensesScreenType: View
    func licensesScreen() -> Self.LicensesScreenType
}

#if DEBUG
public final class SettingsRouterMock {
    public static let shared = SettingsRouterMock()

    private init() {}
}

extension SettingsRouterMock: SettingsRouterProtocol {
    public func licensesScreen() -> some View { EmptyView() }
}
#endif
