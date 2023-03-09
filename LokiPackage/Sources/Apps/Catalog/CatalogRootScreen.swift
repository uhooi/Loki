import SwiftUI
import PlaybookUI

public struct CatalogRootScreen: View {
    public var body: some View {
        PlaybookScreen()
    }

    public init() {
        Playbook.default.add(AllScenarios.self)
    }
}
