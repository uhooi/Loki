import SwiftUI
import CatalogApp

@main
struct CatalogApp: App {
    var body: some Scene {
        WindowGroup {
            CatalogRouter.shared.firstScreen()
        }
    }
}
