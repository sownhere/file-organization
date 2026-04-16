//
//  Root.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture

@Reducer
struct Root {
    @Reducer
    enum Destination {
        case mainNavigation(MainNavigation)
    }
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var appDelegate = AppDelegate.State()
        
        @Presents var destination: Destination.State?
    }
    
    // MARK: - Action
    enum Action {
        case appDelegate(AppDelegate.Action)
        case destination(PresentationAction<Destination.Action>)
    }
    
    // MARK: - Body
    var body: some Reducer<State, Action> {
        Scope(state: \.appDelegate, action: \.appDelegate) {
            AppDelegate()
        }
        
        Reduce { state, action in
            switch action {
            case .appDelegate(.didFinishLaunching):
                state.destination = .mainNavigation(
                    MainNavigation.State(mainTab: MainTab.State())
                )
                return .none
                
            case .appDelegate(.didBecomeActive):
                return .send(.destination(.presented(.mainNavigation(.mainTab(.reloadAll)))))
                
            case .appDelegate:
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension Root.Destination.State: Equatable {}
