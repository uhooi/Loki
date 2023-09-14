import SwiftUI
import SakatsuData

struct SakatsuRowView: View {
    let sakatsu: Sakatsu

    let onCopySakatsuTextButtonClick: () -> Void
    let onEditButtonClick: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    visitingDateText
                    facilityNameText
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                menu
                    .frame(alignment: .topTrailing)
            }
            forewordText
            if !sakatsu.saunaSets.isEmpty {
                GroupBox {
                    saunaSetsView
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(uiColor: .tertiaryLabel))
                }
            }
            afterwordText
            if !sakatsu.saunaTemperatures.isEmpty && sakatsu.saunaTemperatures.contains(where: { $0.temperature != nil }) {
                temperaturesView
            }
        }
    }
}

// MARK: - Privates

private extension SakatsuRowView {
    var visitingDateText: some View {
        Text(sakatsu.visitingDate.formatted(date: .numeric, time: .omitted))
            .font(.caption)
            .lineLimit(1)
            .foregroundStyle(.secondary)
    }

    var facilityNameText: some View {
        Text(sakatsu.facilityName)
            .font(.title)
            .lineLimit(1)
            .textSelection(.enabled)
    }

    var menu: some View {
        Menu {
            Button(action: onCopySakatsuTextButtonClick) {
                Label(String(localized: "Copy Sakatsu text", bundle: .module), systemImage: "doc.on.doc")
            }
            Button(action: onEditButtonClick) {
                Label(String(localized: "Edit", bundle: .module), systemImage: "square.and.pencil")
            }
        } label: {
            Image(systemName: "ellipsis")
                .frame(minWidth: 44, minHeight: 44, alignment: .trailing)
        }
    }

    @ViewBuilder
    var forewordText: some View {
        if let foreword = sakatsu.foreword {
            Text(foreword)
                .font(.body)
                .lineLimit(3)
                .textSelection(.enabled)
        }
    }

    var saunaSetsView: some View {
        ForEach(sakatsu.saunaSets) { saunaSet in
            HStack {
                // TODO: Refactor logic
                if !saunaSet.sauna.title.isEmpty || saunaSet.sauna.time != nil {
                    saunaSetItemView(saunaSetItem: saunaSet.sauna)
                }
                if !saunaSet.coolBath.title.isEmpty || saunaSet.coolBath.time != nil {
                    if !saunaSet.sauna.title.isEmpty || saunaSet.sauna.time != nil {
                        arrowImage
                    }
                    saunaSetItemView(saunaSetItem: saunaSet.coolBath)
                }
                if !saunaSet.relaxation.title.isEmpty || saunaSet.relaxation.time != nil {
                    if (!saunaSet.sauna.title.isEmpty || saunaSet.sauna.time != nil) ||
                        (!saunaSet.coolBath.title.isEmpty || saunaSet.coolBath.time != nil) {
                        arrowImage
                    }
                    saunaSetItemView(saunaSetItem: saunaSet.relaxation)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(1)
        .minimumScaleFactor(0.5)
    }

    var arrowImage: some View {
        Image(systemName: "arrow.right")
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    @ViewBuilder
    var afterwordText: some View {
        if let afterword = sakatsu.afterword {
            Text(afterword)
                .font(.body)
                .lineLimit(1)
                .textSelection(.enabled)
        }
    }

    @ViewBuilder
    func saunaSetItemView(saunaSetItem: any SaunaSetItemProtocol) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(saunaSetItem.emoji)
                .font(.body)
            if let time = saunaSetItem.time {
                Text(time.formatted())
                    .font(.system(.title2, design: .rounded))
                Text(saunaSetItem.unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    var temperaturesView: some View {
        HStack {
            ForEach(sakatsu.saunaTemperatures) { saunaTemperature in
                if let temperature = saunaTemperature.temperature {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text(saunaTemperature.emoji)
                            .font(.footnote)
                        Text(temperature.formatted())
                            .font(.system(.footnote, design: .rounded))
                            .textSelection(.enabled)
                        Text("℃", bundle: .module)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .lineLimit(1)
    }
}

// MARK: - Previews

#Preview {
    SakatsuRowView(
        sakatsu: .preview,
        onCopySakatsuTextButtonClick: {},
        onEditButtonClick: {}
    )
}
