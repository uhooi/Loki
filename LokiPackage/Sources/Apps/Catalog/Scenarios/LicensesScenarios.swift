import Playbook
import LicensesFeature

@MainActor
struct LicensesScenarios: @preconcurrency ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Licenses") {
            Scenario("LicenseList", layout: .fill) {
                LicenseListScreen()
            }
        }
    }
}
