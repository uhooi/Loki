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
                    Button("サ活用テキストコピー", action: onCopySakatsuTextButtonClick)
                } label: {
                    Image(systemName: "ellipsis")
                }
                .frame(alignment: .topTrailing)
            }
            forewordText
            GroupBox {
                saunaSetsView
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
                if let saunaTime = saunaSet.sauna.time {
                    saunaSetView(emoji: "🔥", time: saunaTime, unit: "分")
                }
                if let coolBathTime = saunaSet.coolBath.time {
                    arrowImage
                    saunaSetView(emoji: "💧", time: coolBathTime, unit: "秒")
                }
                if let relaxationTime = saunaSet.relaxation.time {
                    arrowImage
                    saunaSetView(emoji: "🍃", time: relaxationTime, unit: "分")
                }
            }
        }
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
    
    private func saunaSetView(emoji: String, time: TimeInterval, unit: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(emoji)
            Text("\(time.formatted())")
                .font(.system(.title2, design: .rounded))
            Text(unit)
                .font(.caption)
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
