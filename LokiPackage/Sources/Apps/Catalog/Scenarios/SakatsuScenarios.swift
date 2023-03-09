import SwiftUI
import Playbook
import SakatsuFeature

@MainActor
struct SakatsuScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Sakatsu") {
            Scenario("SakatsuList", layout: .fill) {
                NavigationStack {
                    SakatsuListScreen(onSettingsButtonClick: {})
                }
            }
        }
    }
}
