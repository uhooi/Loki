import SwiftUI
import RecordsData

struct RecordRowView: View {
    var sakatsu: Sakatsu
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading) {
                visitingDateText
                facilityNameText
            }
            saunaSetsView
            commentText
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
    
    private var saunaSetsView: some View {
        ForEach(sakatsu.saunaSets) { saunaSet in
            HStack {
                if let saunaTime = saunaSet.sauna.time {
                    saunaSetView(emoji: "🧖", time: saunaTime)
                }
                if let coolBathTime = saunaSet.coolBath.time {
                    arrowImage
                    saunaSetView(emoji: "💧", time: coolBathTime)
                }
                if let relaxationTime = saunaSet.relaxation.time {
                    arrowImage
                    saunaSetView(emoji: "🍃", time: relaxationTime)
                }
            }
        }
    }
    
    private var arrowImage: some View {
        Image(systemName: "arrow.right")
            .font(.caption)
    }
    
    private var commentText: some View {
        Text(sakatsu.comment ?? "")
            .font(.body)
    }
    
    private func saunaSetView(emoji: String, time: TimeInterval) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(emoji)
            Text("\(time.formatted())")
                .font(.system(.title2, design: .rounded))
            Text("秒")
                .font(.caption)
        }
    }
}

struct RecordRowView_Previews: PreviewProvider {
    static var previews: some View {
        RecordRowView(sakatsu: Sakatsu.preview)
    }
}
