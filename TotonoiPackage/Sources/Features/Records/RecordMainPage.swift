import SwiftUI

public struct RecordMainPage: View {
    public init() {
    }
    
    public var body: some View {
        RecordMainView()
    }
}

private struct RecordMainView: View {
    var body: some View {
        Text("Hello, Totonoi!")
    }
}

struct RecordsMainView: PreviewProvider {
    static var previews: some View {
        RecordMainView()
    }
}
