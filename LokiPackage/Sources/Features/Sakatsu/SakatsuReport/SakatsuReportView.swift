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
                cellView(title: "サ活", emoji: "🧖", value: 199)

                cellView(title: "サウナ", emoji: "🔥", value: 30)
            }

            HStack(spacing: 16) {
                cellView(title: "水風呂", emoji: "💧", value: 300)

                cellView(title: "休憩", emoji: "🍃", value: 30)
            }
        }
        .padding(16)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

// MARK: - Privates

private extension SakatsuReportView {
    func cellView(
        title: String,
        emoji: String,
        value: Int,
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(emoji)
                    .font(.title)

                Spacer()

                Text("\(value)")
                    .font(.system(.title, design: .rounded).bold())
            }

            Text(title)
                .font(.body.bold())
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.leading, 12)
        .padding(.trailing, 14)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }
}

#if DEBUG
// MARK: - Previews

#Preview {
    SakatsuReportView(
        send: { _ in },
    )
}

#endif
