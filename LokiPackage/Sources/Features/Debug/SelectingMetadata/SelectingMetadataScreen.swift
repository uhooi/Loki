import SwiftUI

struct SelectingMetadataScreen: View {
    @Binding var selectedMetadata: Set<Metadata>

    @Environment(\.dismiss) private var dismiss // swiftlint:disable:this attributes

    var body: some View {
        List(selection: $selectedMetadata) {
            ForEach(Metadata.allCases) { metadata in
                LabeledContent(metadata.text) {
                    Image(systemName: metadata.iconName) // swiftlint:disable:this accessibility_label_for_image
                }
            }
        }
        .environment(\.editMode, .constant(.active))
        .navigationTitle(String(localized: "Metadata", bundle: .module))
        .selectingMetadataScreenToolbar(
            onCloseButtonClick: {
                dismiss()
            }
        )
    }
}

// MARK: - Privates

private extension View {
    func selectingMetadataScreenToolbar(
        onCloseButtonClick: @escaping () -> Void
    ) -> some View {
        toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    onCloseButtonClick()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}
