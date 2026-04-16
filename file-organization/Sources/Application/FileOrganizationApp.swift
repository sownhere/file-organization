//
//  FileOrganizationApp.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
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
                .onOpenURL { url in
                    appDelegateAdaptor.store.send(.appDelegate(.openURL(url)))
                }
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
