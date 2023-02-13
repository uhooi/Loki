import Playbook

struct AllScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook
            .add(SakatsuScenarios.self)
            .add(SettingsScenarios.self)
            .add(FloatingActionButtonScenarios.self)
    }
}
