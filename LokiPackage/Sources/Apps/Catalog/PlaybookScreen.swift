import SwiftUI
import PlaybookUI

struct PlaybookScreen: View {
    enum Tab {
        case catalog
        case gallery
    }

    @State var tab: Tab = .gallery

    var body: some View {
        TabView(selection: $tab) {
            PlaybookGallery()
                .tag(Tab.gallery)
                .tabItem {
                    Image(systemName: "rectangle.grid.3x2")
                        .accessibilityHidden(true)
                    Text("Gallery")
                }

            PlaybookCatalog()
                .tag(Tab.catalog)
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                        .accessibilityHidden(true)
                    Text("Catalog")
                }
        }
    }
}
