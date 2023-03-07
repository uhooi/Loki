import SwiftUI

@MainActor
public protocol SettingsRouterProtocol {
    associatedtype LicenseListScreenType: View
    func licenseListScreen() -> Self.LicenseListScreenType
}

#if DEBUG
public final class SettingsRouterMock {
    public static let shared = SettingsRouterMock()

    private init() {}
}

extension SettingsRouterMock: SettingsRouterProtocol {
    public func licenseListScreen() -> some View { EmptyView() }
}
#endif
