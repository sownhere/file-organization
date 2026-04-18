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
        case pdfViewer(PDFViewer)
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
        
        Reduce { state, action in
            switch action {
            case let .mainTab(.delegate(.openPDF(file))):
                state.path.append(.pdfViewer(PDFViewer.State(file: file)))
                return .none
                
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
