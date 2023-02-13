import SwiftUI
import Playbook
import UICore

@MainActor
struct FloatingActionButtonScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "FloatingActionButton") {
            Scenario("Enabled", layout: .compressed) {
                VStack {
                    FAB(systemName: "plus") {}
                    FAB(systemName: "plus", backgroundColor: .black) {}
                    FAB(systemName: "plus", foregroundColor: .black) {}
                    FAB(systemName: "plus", backgroundColor: .green, foregroundColor: .black) {}
                }
            }
                    
            Scenario("Disabled", layout: .compressed) {
                VStack {
                    FAB(systemName: "plus") {}
                    FAB(systemName: "plus", backgroundColor: .black) {}
                    FAB(systemName: "plus", foregroundColor: .black) {}
                    FAB(systemName: "plus", backgroundColor: .green, foregroundColor: .black) {}
                }
                .disabled(true)
            }
        }
    }
}
