//
//  RootView.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
import SwiftUI

struct RootView: View {
    // MARK: - Store
    @Bindable var store: StoreOf<Root>
    
    // MARK: - Body
    var body: some View {
        ZStack {
            if let store = store.scope(
                state: \.destination?.mainNavigation,
                action: \.destination.mainNavigation
            ) {
                MainNavigationView(store: store)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.24), value: store.destination)
    }
}
