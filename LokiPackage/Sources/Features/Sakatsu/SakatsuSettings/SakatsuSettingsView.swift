import SwiftUI
import SakatsuData

struct SakatsuSettingsView: View {
    let defaultSaunaTimes: DefaultSaunaTimes

    let onDefaultSaunaTimeChange: ((TimeInterval?) -> Void)
    let onDefaultCoolBathTimeChange: ((TimeInterval?) -> Void)
    let onDefaultRelaxationTimeChange: ((TimeInterval?) -> Void)

    var body: some View {
        Form {
            defaultSaunaSetsSection
            versionSection
        }
    }

    private var defaultSaunaSetsSection: some View {
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

    private var versionSection: some View {
        Section {
            HStack {
                Text("Version", bundle: .module)
                Spacer()
                Text("\(Bundle.main.version) (\(Bundle.main.build))")
            }
        } footer: {
            Text("© 2023 THE Uhooi")
        }
    }

    private func defaultTimeInputView(
        emoji: String,
        title: String,
        defaultTime: TimeInterval?,
        unit: String,
        onTimeChange: @escaping (TimeInterval?) -> Void
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

#if DEBUG
struct SakatsuSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SakatsuSettingsView(
            defaultSaunaTimes: .preview,
            onDefaultSaunaTimeChange: { _ in },
            onDefaultCoolBathTimeChange: { _ in },
            onDefaultRelaxationTimeChange: { _ in }
        )
    }
}
#endif
