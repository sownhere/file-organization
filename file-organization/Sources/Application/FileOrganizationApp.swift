import ComposableArchitecture
import SwiftUI

@main
struct FileOrganizationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegateAdaptor.self)
    private var appDelegateAdaptor

    @Environment(\.scenePhase)
    private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView(store: appDelegateAdaptor.store)
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                appDelegateAdaptor.store.send(.appDelegate(.didBecomeActive))
            case .background:
                appDelegateAdaptor.store.send(.appDelegate(.didEnterBackground))
            case .inactive:
                appDelegateAdaptor.store.send(.appDelegate(.updateReminder))
            @unknown default:
                break
            }
        }
    }
}
