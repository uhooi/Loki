import SwiftUI
import SakatsuData

struct SakatsuRowView: View {
    var sakatsu: Sakatsu
    let onEditButtonClick: () -> Void
    let onCopySakatsuTextButtonClick: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    visitingDateText
                    facilityNameText
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                Menu {
                    Button("編集", action: onEditButtonClick)
                    Button("サ活テキストコピー", action: onCopySakatsuTextButtonClick)
                } label: {
                    Image(systemName: "ellipsis")
                }
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
    }
    
    @ViewBuilder
    private var forewordText: some View {
        if let foreword = sakatsu.foreword {
            Text(foreword)
                .font(.body)
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
            onEditButtonClick: {},
            onCopySakatsuTextButtonClick: {}
        )
    }
}
