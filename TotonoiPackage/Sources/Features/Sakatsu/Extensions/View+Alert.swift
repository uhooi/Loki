import SwiftUI

extension View {
    func errorAlert(
        error: (some LocalizedError)?,
        onDismiss: @escaping () -> Void
    ) -> some View {
        alert(
            isPresented: .init(get: {
                error != nil
            }, set: { _ in
                onDismiss()
            }),
            error: error
        ) { _ in
        } message: { error in
            Text((error.failureReason ?? "") + (error.recoverySuggestion ?? ""))
        }
    }
}
