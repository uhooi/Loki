import Playbook

@MainActor
struct SettingsScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Settings") {
            Scenario("Settings", layout: .fill) {
                CatalogRouter.shared.settingsScreen()
            }
        }
    }
}
