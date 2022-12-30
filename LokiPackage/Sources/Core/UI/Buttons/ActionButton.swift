import SwiftUI

public struct ActionButton: View {
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
        .buttonStyle(.action(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor
        ))
    }
    
    public init(
        systemName: String,
        backgroundColor: Color,
        foregroundColor: Color = .white,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.action = action
    }
}

#if DEBUG
struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(
            systemName: "plus",
            backgroundColor: .blue,
            action: { print("Foo") }
        )
    }
}
#endif

private extension ButtonStyle where Self == ActionButtonStyle {
    static func action(
        backgroundColor: Color,
        foregroundColor: Color
    ) -> ActionButtonStyle {
        .init(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor
        )
    }
}

private struct ActionButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 56, height: 56)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(16)
    }
}
