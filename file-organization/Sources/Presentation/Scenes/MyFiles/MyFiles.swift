//
//  MyFiles.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
import Foundation

private nonisolated enum MyFilesCancelID: Hashable, Sendable { case load }

@Reducer
struct MyFiles {
    enum Sort: String, CaseIterable, Equatable, Sendable {
        case dateAdded
        case dateModified
        
        var displayName: String {
            switch self {
            case .dateAdded: "Date Added"
            case .dateModified: "Date Modified"
            }
        }
    }
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var files: [FileItem] = []
        var sort: Sort = .dateModified
        var viewMode: Recents.ViewMode = .list
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case reload
        case filesLoaded([FileItem])
        case loadFailed
        case toggleViewMode
        case fileTapped(FileItem)
    }
    
    @Dependency(\.fileStorageClient)
    private var storage
    
    // MARK: - Body
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding(\.sort):
                state.files = Self.sorted(state.files, by: state.sort)
                return .none
                
            case .binding:
                return .none
                
            case .onAppear, .reload:
                return .run { [storage] send in
                    do {
                        let files = try storage.load()
                        await send(.filesLoaded(files))
                    } catch {
                        await send(.loadFailed)
                    }
                }
                .cancellable(id: MyFilesCancelID.load, cancelInFlight: true)
                
            case let .filesLoaded(files):
                state.files = Self.sorted(files, by: state.sort)
                return .none
                
            case .loadFailed:
                return .none
                
            case .toggleViewMode:
                state.viewMode = state.viewMode == .grid ? .list : .grid
                return .none
                
            case .fileTapped:
                return .none
            }
        }
    }
    
    private static func sorted(_ files: [FileItem], by sort: Sort) -> [FileItem] {
        switch sort {
        case .dateAdded:
            files.sorted { $0.createdAt > $1.createdAt }
        case .dateModified:
            files.sorted { $0.modifiedAt > $1.modifiedAt }
        }
    }
}
