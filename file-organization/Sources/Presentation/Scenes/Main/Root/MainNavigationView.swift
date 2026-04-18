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
    @Bindable var store: StoreOf<MainNavigation>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            MainTabView(store: store.scope(state: \.mainTab, action: \.mainTab))
        } destination: { pathStore in
            MainNavigationPathDestinationView(store: pathStore)
        }
    }
}

// MARK: - Stack destinations

private struct MainNavigationPathDestinationView: View {
    @Bindable var store: StoreOf<MainNavigation.Path>

    var body: some View {
        switch store.case {
        case let .pdfViewer(pdfStore):
            PDFViewerView(store: pdfStore)
        }
    }
}
