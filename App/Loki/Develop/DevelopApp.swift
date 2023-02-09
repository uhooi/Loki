import SwiftUI
import DevelopApp

@main
struct DevelopApp: App {
    var body: some Scene {
        WindowGroup {
            DevelopRouter.shared.firstScreen()
        }
    }
}
