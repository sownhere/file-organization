//
//  MainNavigation.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
import Foundation

@Reducer
struct MainNavigation {
    @Reducer
    enum Path {
        // Future push destinations go here
        // case fileDetail(FileDetail)
    }
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var mainTab: MainTab.State
    }
    
    // MARK: - Action
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case mainTab(MainTab.Action)
    }
    
    // MARK: - Body
    var body: some Reducer<State, Action> {
        Scope(state: \.mainTab, action: \.mainTab) {
            MainTab()
        }
        
        Reduce { _, action in
            switch action {
            case .mainTab:
                return .none
                
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension MainNavigation.Path.State: Equatable {}
