import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    let store: StoreOf<Home>

    var body: some View {
        AdaptiveView {
            PhoneHomeView(store: store)
        } pad: {
            PadHomeView(store: store)
        }
    }
}
