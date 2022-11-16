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
            }
            afterwordText
        }
    }
    
    private var visitingDateText: some View {
        Text(sakatsu.visitingDate.formatted(date: .numeric, time: .omitted))
            .font(.caption)
            .foregroundColor(.secondary)
    }
    
    private var facilityNameText: some View {
        Text(sakatsu.facilityName)
            .font(.title)
            .textSelection(.enabled)
    }
    
    private var menu: some View {
        Menu {
            Button(action: onCopySakatsuTextButtonClick) {
                Label("サ活のテキストをコピー", systemImage: "doc.on.doc")
            }
            Button(action: onEditButtonClick) {
                Label("編集", systemImage: "square.and.pencil")
            }
        } label: {
            Image(systemName: "ellipsis")
        }
    }
    
    @ViewBuilder
    private var forewordText: some View {
        if let foreword = sakatsu.foreword {
            Text(foreword)
                .font(.body)
                .textSelection(.enabled)
        }
    }
    
    private var saunaSetsView: some View {
        ForEach(sakatsu.saunaSets) { saunaSet in
            HStack {
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
    }
    
    private var arrowImage: some View {
        Image(systemName: "arrow.right")
            .font(.caption)
    }
    
    @ViewBuilder
    private var afterwordText: some View {
        if let afterword = sakatsu.afterword {
            Text(afterword)
                .font(.body)
                .textSelection(.enabled)
        }
    }
    
    @ViewBuilder
    private func saunaSetItemView(saunaSetItem: any SaunaSetItemProtocol) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(saunaSetItem.emoji)
            if let time = saunaSetItem.time {
                Text("\(time.formatted())")
                    .font(.system(.title2, design: .rounded))
                Text(saunaSetItem.unit)
                    .font(.caption)
            }
        }
    }
}

struct SakatsuRowView_Previews: PreviewProvider {
    static var previews: some View {
        SakatsuRowView(
            sakatsu: .preview,
            onCopySakatsuTextButtonClick: {},
            onEditButtonClick: {}
        )
    }
}
