import SwiftUI

public typealias FAB = FloatingActionButton

public struct FloatingActionButton: View {
    private let systemName: String
    private let backgroundColor: Color
    private let foregroundColor: Color
    private let action: () -> Void

    public var body: some View {
        Button(
            action: action,
            label: {
                Image(systemName: systemName)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        )
        .buttonStyle(.floatingAction(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor
        ))
    }

    public init(
        systemName: String,
        backgroundColor: Color = .accentColor,
        foregroundColor: Color = .white,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.action = action
    }
}

// MARK: - Previews

#if DEBUG
struct FloatingActionButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingActionButton(
            systemName: "plus",
            action: {}
        )
    }
}
#endif

// MARK: - Privates

private extension ButtonStyle where Self == FloatingActionButtonStyle {
    static func floatingAction(
        backgroundColor: Color,
        foregroundColor: Color
    ) -> Self {
        .init(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor
        )
    }
}

private struct FloatingActionButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 56, height: 56)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(16)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
