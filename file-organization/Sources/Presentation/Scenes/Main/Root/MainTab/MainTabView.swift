//
//  MainTabView.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
import SwiftUI

struct MainTabView: View {
    @Bindable var store: StoreOf<MainTab>

    var body: some View {
        tabView
    }
}

// MARK: - Content

private extension MainTabView {
    var tabView: some View {
        TabView(selection: $store.selectedTab.sending(\.selectedTabChanged)) {
            RecentsView(store: store.scope(state: \.recents, action: \.recents))
                .tabItem {
                    Label(
                        MainTabItem.recents.tabItemTitle,
                        systemImage: MainTabItem.recents.systemImageName
                    )
                    .symbolEffect(.bounce, value: store.selectedTab)
                }
                .tag(MainTabItem.recents)

            MyFilesView(store: store.scope(state: \.myFiles, action: \.myFiles))
                .tabItem {
                    Label(
                        MainTabItem.myFiles.tabItemTitle,
                        systemImage: MainTabItem.myFiles.systemImageName
                    )
                    .symbolEffect(.bounce, value: store.selectedTab)
                }
                .tag(MainTabItem.myFiles)

            Text("Action")
                .tabItem {
                    Label(
                        MainTabItem.action.tabItemTitle,
                        systemImage: MainTabItem.action.systemImageName
                    )
                    .symbolEffect(.bounce, value: store.selectedTab)
                }
                .tag(MainTabItem.action)

            Text("Setting")
                .tabItem {
                    Label(
                        MainTabItem.setting.tabItemTitle,
                        systemImage: MainTabItem.setting.systemImageName
                    )
                    .symbolEffect(.bounce, value: store.selectedTab)
                }
                .tag(MainTabItem.setting)
        }
    }
}
