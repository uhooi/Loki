import SwiftUI
import SakatsuData

struct SettingsView: View {
    let defaultSaunaTimes: DefaultSaunaTimes

    let onDefaultSaunaTimeChange: (_ defaultSaunaTime: TimeInterval?) -> Void
    let onDefaultCoolBathTimeChange: (_ defaultCoolBathTime: TimeInterval?) -> Void
    let onDefaultRelaxationTimeChange: (_ defaultRelaxationTime: TimeInterval?) -> Void
    let onLicensesButtonClick: () -> Void

    var body: some View {
        Form {
            defaultSaunaSetsSection
            licensesSection
            versionSection
        }
    }
}

// MARK: - Privates

private extension SettingsView {
    var defaultSaunaSetsSection: some View {
        Section {
            defaultTimeInputView(
                emoji: "🔥",
                title: String(localized: "Sauna", bundle: .module),
                defaultTime: defaultSaunaTimes.saunaTime,
                unit: String(localized: "m", bundle: .module),
                onTimeChange: onDefaultSaunaTimeChange
            )
            defaultTimeInputView(
                emoji: "💧",
                title: String(localized: "Cool bath", bundle: .module),
                defaultTime: defaultSaunaTimes.coolBathTime,
                unit: String(localized: "s", bundle: .module),
                onTimeChange: onDefaultCoolBathTimeChange
            )
            defaultTimeInputView(
                emoji: "🍃",
                title: String(localized: "Relaxation", bundle: .module),
                defaultTime: defaultSaunaTimes.relaxationTime,
                unit: String(localized: "m", bundle: .module),
                onTimeChange: onDefaultRelaxationTimeChange
            )
        } header: {
            Text("Default times", bundle: .module)
        }
    }

    var licensesSection: some View {
        Section {
            Button(String(localized: "Licenses", bundle: .module), action: onLicensesButtonClick)
        }
    }

    var versionSection: some View {
        Section {
            LabeledContent(
                String(localized: "Version", bundle: .module),
                value: "\(Bundle.main.version) (\(Bundle.main.build))"
            )
        } footer: {
            Text("© 2023 THE Uhooi", bundle: .module)
        }
    }

    func defaultTimeInputView(
        emoji: String,
        title: String,
        defaultTime: TimeInterval?,
        unit: String,
        onTimeChange: @escaping (_ time: TimeInterval?) -> Void
    ) -> some View {
        HStack {
            Text(emoji + title)
            TextField(String(localized: "Optional", bundle: .module), value: .init(get: {
                defaultTime
            }, set: { newValue in
                onTimeChange(newValue)
            }), format: .number)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            Text(unit)
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview {
    SettingsView(
        defaultSaunaTimes: .preview,
        onDefaultSaunaTimeChange: { _ in },
        onDefaultCoolBathTimeChange: { _ in },
        onDefaultRelaxationTimeChange: { _ in },
        onLicensesButtonClick: {}
    )
}
#endif
