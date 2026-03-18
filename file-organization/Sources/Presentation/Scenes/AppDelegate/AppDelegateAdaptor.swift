import ComposableArchitecture
import UIKit

final class AppDelegateAdaptor: UIResponder, UIApplicationDelegate {
    let store = Store(initialState: Root.State()) {
        Root()
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        setupNavigationBar()
        setupTabBar()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let notificationType = (options.notificationResponse?.notification.request.content.userInfo["type"] as? String)
        store.send(.appDelegate(.didFinishLaunching(fromNotificationType: notificationType)))
        return UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        store.send(.appDelegate(.didRegisterForRemoteNotifications(.success(deviceToken))))
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        store.send(.appDelegate(.didRegisterForRemoteNotifications(.failure(error))))
    }

    func applicationWillTerminate(_ application: UIApplication) {
        store.send(.appDelegate(.updateReminder))
    }
}

private extension AppDelegateAdaptor {
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppTheme.UIKitColors.navigationBackground
        appearance.shadowColor = AppTheme.UIKitColors.separator
        appearance.titleTextAttributes = [
            .foregroundColor: AppTheme.UIKitColors.primaryText
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: AppTheme.UIKitColors.primaryText
        ]

        let navigationBar = UINavigationBar.appearance()
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactScrollEdgeAppearance = appearance
        navigationBar.tintColor = AppTheme.UIKitColors.primaryText
    }

    func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppTheme.UIKitColors.tabBarBackground
        appearance.shadowColor = AppTheme.UIKitColors.separator

        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = AppTheme.UIKitColors.primaryText
    }
}
