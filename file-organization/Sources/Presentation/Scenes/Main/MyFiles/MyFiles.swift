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
        var listPresentation: FileListPresentation = .pending
    }
    
    // MARK: - Action
    enum Action {
        case task
        case reload
        case sortChanged(Sort)
        case filesLoaded([FileItem])
        case loadFailed(String)
        case toggleViewMode
        case fileTapped(FileItem)
        case delegate(Delegate)
    }
    
    enum Delegate: Equatable {
        case openPDF(FileItem)
    }
    
    @Dependency(\.fileStorageClient)
    private var storage
    
    // MARK: - Body
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .sortChanged(sort):
                state.sort = sort
                state.files = Self.sorted(state.files, by: sort)
                return .none
                
            case .task, .reload:
                state.listPresentation = .loading
                return .run { [storage] send in
                    let files = try storage.load()
                    await send(.filesLoaded(files))
                } catch: { error, send in
                    await send(.loadFailed(error.localizedDescription))
                }
                .cancellable(id: MyFilesCancelID.load, cancelInFlight: true)
                
            case let .filesLoaded(files):
                state.files = Self.sorted(files, by: state.sort)
                state.listPresentation = .ready
                return .none
                
            case let .loadFailed(message):
                state.listPresentation = .failed(message)
                return .none
                
            case .toggleViewMode:
                state.viewMode = state.viewMode == .grid ? .list : .grid
                return .none
                
            case let .fileTapped(file):
                if file.fileType == .pdf {
                    return .send(.delegate(.openPDF(file)))
                }
                return .none
                
            case .delegate:
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
