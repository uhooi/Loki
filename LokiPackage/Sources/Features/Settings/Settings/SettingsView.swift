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
                title: L10n.sauna,
                defaultTime: defaultSaunaTimes.saunaTime,
                unit: L10n.m,
                onTimeChange: onDefaultSaunaTimeChange
            )
            defaultTimeInputView(
                emoji: "💧",
                title: L10n.coolBath,
                defaultTime: defaultSaunaTimes.coolBathTime,
                unit: L10n.s,
                onTimeChange: onDefaultCoolBathTimeChange
            )
            defaultTimeInputView(
                emoji: "🍃",
                title: L10n.relaxation,
                defaultTime: defaultSaunaTimes.relaxationTime,
                unit: L10n.m,
                onTimeChange: onDefaultRelaxationTimeChange
            )
        } header: {
            Text(L10n.defaultTimes)
        }
    }

    var licensesSection: some View {
        Section {
            Button(L10n.licenses, action: onLicensesButtonClick)
        }
    }

    var versionSection: some View {
        Section {
            LabeledContent(
                L10n.version,
                value: "\(Bundle.main.version) (\(Bundle.main.build))"
            )
        } footer: {
            Text("© 2023 THE Uhooi")
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
            TextField(L10n.optional, value: .init(get: {
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

#Preview {
    SettingsView(
        defaultSaunaTimes: .preview,
        onDefaultSaunaTimeChange: { _ in },
        onDefaultCoolBathTimeChange: { _ in },
        onDefaultRelaxationTimeChange: { _ in },
        onLicensesButtonClick: {}
    )
}
