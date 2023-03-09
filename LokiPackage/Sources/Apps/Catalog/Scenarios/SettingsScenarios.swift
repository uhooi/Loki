import SwiftUI
import Playbook
import SettingsFeature

@MainActor
struct SettingsScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Settings") {
            Scenario("Settings", layout: .fill) {
                NavigationStack {
                    SettingsScreen(onLicensesButtonClick: {})
                }
            }
        }
    }
}
