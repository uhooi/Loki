import SwiftUI
import ProductionApp

@main
struct ProductionApp: App {
    var body: some Scene {
        WindowGroup {
            ProductionRouter.shared.firstScreen()
        }
    }
}
