import Foundation
import LogCore

// MARK: UI state

struct SakatsuReportUiState {
}

// MARK: - Actions

enum SakatsuReportAction {
    case screen(_ action: SakatsuReportScreenAction)
    case view(_ action: SakatsuReportViewAction)
}

enum SakatsuReportAsyncAction {
    case screen(_ asyncAction: SakatsuReportScreenAsyncAction)
    case view(_ asyncAction: SakatsuReportViewAsyncAction)
}

// MARK: - Error

enum SakatsuReportError: LocalizedError {
}

// MARK: - View model

@MainActor
final class SakatsuReportViewModel: ObservableObject {
    @Published private(set) var uiState: SakatsuReportUiState

    init(
    ) {
        self.uiState = SakatsuReportUiState()
    }

    func send(_ action: SakatsuReportAction) { // swiftlint:disable:this cyclomatic_complexity function_body_length
        let message = "\(#function) action: \(action)"
        Logger.standard.debug("\(message, privacy: .public)")

        //        switch action {
        //        case let .screen(screenAction):
        //            switch screenAction {
        //            }
        //
        //        case let .view(viewAction):
        //            switch viewAction {
        //            }
        //        }
    }

    func sendAsync(_ asyncAction: SakatsuReportAsyncAction) async {
        let message = "\(#function) asyncAction: \(asyncAction)"
        Logger.standard.debug("\(message, privacy: .public)")

        //        switch asyncAction {
        //        case let .screen(screenAsyncAction):
        //            switch screenAsyncAction {
        //            }
        //
        //        case let .view(viewAsyncAction):
        //            switch viewAsyncAction {
        //            }
        //        }
    }
}

// MARK: - Privates

private extension SakatsuReportViewModel {
}
