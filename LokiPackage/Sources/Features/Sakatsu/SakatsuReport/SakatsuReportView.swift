import SwiftUI

// MARK: Actions

enum SakatsuReportViewAction {
}

enum SakatsuReportViewAsyncAction {
}

// MARK: - View

struct SakatsuReportView: View {
    let send: (SakatsuListViewAction) -> Void

    var body: some View {
        // TODO: Use real data
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                cellView(title: "サウナ", emoji: "🔥", value: 30)

                cellView(title: "水風呂", emoji: "💧", value: 300)
            }

            HStack(spacing: 16) {
                cellView(title: "休憩", emoji: "🍃", value: 30)

                cellView(title: "サ活", emoji: "🧖", value: 199)
            }
        }
        .padding(16)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color(uiColor: .secondarySystemBackground))
    }
}

// MARK: - Privates

private extension SakatsuReportView {
    func cellView(
        title: String,
        emoji: String,
        value: Int,
    ) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(emoji)
                    .font(.title)

                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(value)")
                .font(.system(.title, design: .rounded).bold())
        }
        .padding(16)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
    }
}
