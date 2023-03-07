import Playbook

@MainActor
struct LicensesScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook.addScenarios(of: "Licenses") {
            Scenario("LicenseList", layout: .fill) {
                CatalogRouter.shared.licenseListScreen()
            }
        }
    }
}
