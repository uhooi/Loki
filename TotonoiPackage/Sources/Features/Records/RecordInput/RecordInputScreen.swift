import SwiftUI

struct RecordInputScreen: View {
    @StateObject private var viewModel = RecordInputViewModel()
    
    var body: some View {
        RecordInputView()
    }
}

struct RecordInputView: View {
    var body: some View {
        Text("Foo")
    }
}

struct RecordInputView_Previews: PreviewProvider {
    static var previews: some View {
        RecordInputView()
    }
}
