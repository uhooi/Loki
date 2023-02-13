import SwiftUI
import Playbook

@MainActor
struct SakatsuScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Sakatsu") {
            Scenario("SakatsuList", layout: .fill) {
                CatalogRouter.shared.sakatsuListScreen()
            }
        }
    }
}
