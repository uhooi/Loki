import SwiftUI
import SakatsuData

struct SakatsuSettingsView: View {
    let defaultSaunaSet: SaunaSet
    
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
            saunaSetItemTimeInputView(
                saunaSetItem: defaultSaunaSet.sauna,
                onTimeChange: onDefaultSaunaTimeChange
            )
            saunaSetItemTimeInputView(
                saunaSetItem: defaultSaunaSet.coolBath,
                onTimeChange: onDefaultCoolBathTimeChange
            )
            saunaSetItemTimeInputView(
                saunaSetItem: defaultSaunaSet.relaxation,
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
    
    private func saunaSetItemTimeInputView(
        saunaSetItem: any SaunaSetItemProtocol,
        onTimeChange: @escaping (TimeInterval?) -> Void
    ) -> some View {
        HStack {
            Text(saunaSetItem.emoji + saunaSetItem.title)
            TextField(String(localized: "Optional", bundle: .module), value: .init(get: {
                saunaSetItem.time
            }, set: { newValue in
                onTimeChange(newValue)
            }), format: .number)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            Text(saunaSetItem.unit)
        }
    }
}

#if DEBUG
struct SakatsuSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SakatsuSettingsView(
            defaultSaunaSet: .preview,
            onDefaultSaunaTimeChange: { _ in },
            onDefaultCoolBathTimeChange: { _ in },
            onDefaultRelaxationTimeChange: { _ in }
        )
    }
}
#endif
