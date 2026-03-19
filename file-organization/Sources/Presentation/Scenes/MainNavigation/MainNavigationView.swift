//
//  MainNavigationView.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
import SwiftUI

struct MainNavigationView: View {
    // MARK: - Store
    @Bindable var store: StoreOf<MainNavigation>
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            MainTabView(store: store.scope(state: \.mainTab, action: \.mainTab))
        } destination: { store in
            switch store.state {
            default:
                EmptyView()
            }
        }
    }
}
