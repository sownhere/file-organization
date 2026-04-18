//
//  MainTab.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
import Foundation

@Reducer
struct MainTab {
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var recents = Recents.State()
        var myFiles = MyFiles.State()
        var selectedTab: MainTabItem = .recents
    }
    
    // MARK: - Action
    enum Action {
        case recents(Recents.Action)
        case myFiles(MyFiles.Action)
        case selectedTabChanged(MainTabItem)
        case reloadAll
        case delegate(Delegate)
    }
    
    enum Delegate: Equatable {
        case openPDF(FileItem)
    }
    
    // MARK: - Body
    var body: some Reducer<State, Action> {
        Scope(state: \.recents, action: \.recents) {
            Recents()
        }
        Scope(state: \.myFiles, action: \.myFiles) {
            MyFiles()
        }
        
        Reduce { state, action in
            switch action {
            case let .selectedTabChanged(tab):
                return selectTab(tab, state: &state)
                
            case .reloadAll:
                return .merge(
                    .send(.recents(.reload)),
                    .send(.myFiles(.reload))
                )
                
            case let .recents(.delegate(.openPDF(file))):
                return .send(.delegate(.openPDF(file)))
                
            case let .myFiles(.delegate(.openPDF(file))):
                return .send(.delegate(.openPDF(file)))
                
            case .recents, .myFiles, .delegate:
                return .none
            }
        }
    }
}

// MARK: - Private Methods
private extension MainTab {
    func selectTab(_ tab: MainTabItem, state: inout State) -> Effect<Action> {
        guard state.selectedTab != tab else { return .none }
        state.selectedTab = tab
        return .none
    }
}
