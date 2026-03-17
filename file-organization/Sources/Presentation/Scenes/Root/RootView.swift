import ComposableArchitecture
import SwiftUI

struct RootView: View {
    @Bindable var store: StoreOf<Root>

    var body: some View {
        ZStack {
            if let store = store.scope(state: \.destination?.home, action: \.destination.home) {
                HomeView(store: store)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.24), value: store.destination)
    }
}
