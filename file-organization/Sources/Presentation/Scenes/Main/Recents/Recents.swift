//
//  Recents.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
import Foundation

private nonisolated enum RecentsCancelID: Hashable, Sendable { case load }

@Reducer
struct Recents {
    // MARK: - State
    enum ViewMode: Sendable, Equatable {
        case grid
        case list
    }
    
    @ObservableState
    struct State: Equatable {
        var viewMode: ViewMode = .grid
        var isSelectionMode = false
        var selectedFileIDs: Set<UUID> = []
        var groupedFiles: [FileGroup] = []
        var listPresentation: FileListPresentation = .pending
    }
    
    // MARK: - Action
    enum Action {
        case task
        case reload
        case filesLoaded([FileItem])
        case loadFailed(String)
        case toggleViewMode
        case toggleSelectionMode
        case toggleFileSelection(UUID)
        case searchTapped
        case fileTapped(FileItem)
        case fileMenuTapped(FileItem)
        case fabTapped
        case delegate(Delegate)
    }
    
    enum Delegate: Equatable {
        case openPDF(FileItem)
    }
    
    // MARK: - Dependencies
    @Dependency(\.fileStorageClient)
    private var storage
    
    @Dependency(\.date.now)
    private var now
    
    @Dependency(\.calendar)
    private var calendar
    
    // MARK: - Body
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .task, .reload:
                state.listPresentation = .loading
                return .run { [storage] send in
                    let files = try storage.load()
                    await send(.filesLoaded(files))
                } catch: { error, send in
                    await send(.loadFailed(error.localizedDescription))
                }
                .cancellable(id: RecentsCancelID.load, cancelInFlight: true)
            case let .filesLoaded(files):
                let sorted = files.sorted { $0.createdAt > $1.createdAt }
                state.groupedFiles = FileGroup.group(
                    files: sorted,
                    relativeTo: now,
                    calendar: calendar
                )
                state.listPresentation = .ready
                return .none
                
            case let .loadFailed(message):
                state.listPresentation = .failed(message)
                return .none
                
            case .toggleViewMode:
                state.viewMode = state.viewMode == .grid ? .list : .grid
                return .none
                
            case .toggleSelectionMode:
                state.isSelectionMode.toggle()
                if !state.isSelectionMode {
                    state.selectedFileIDs.removeAll()
                }
                return .none
                
            case .toggleFileSelection(let fileID):
                if state.selectedFileIDs.contains(fileID) {
                    state.selectedFileIDs.remove(fileID)
                } else {
                    state.selectedFileIDs.insert(fileID)
                }
                return .none
                
            case let .fileTapped(file):
                if file.fileType == .pdf {
                    return .send(.delegate(.openPDF(file)))
                }
                return .none
                
            case .searchTapped,
                    .fileMenuTapped,
                    .fabTapped,
                    .delegate:
                return .none
            }
        }
    }
}

// MARK: - FileGroup
struct FileGroup: Sendable, Equatable, Identifiable {
    let id: String
    let title: String
    let files: [FileItem]
}

extension FileGroup {
    static func group(
        files: [FileItem],
        relativeTo now: Date,
        calendar: Calendar
    ) -> [FileGroup] {
        var today: [FileItem] = []
        var lastWeek: [FileItem] = []
        var earlier: [FileItem] = []
        
        let startOfToday = calendar.startOfDay(for: now)
        guard let startOfWeek = calendar.date(byAdding: .day, value: -7, to: startOfToday) else {
            return []
        }
        
        for file in files {
            if calendar.isDate(file.createdAt, inSameDayAs: now) {
                today.append(file)
            } else if file.createdAt >= startOfWeek {
                lastWeek.append(file)
            } else {
                earlier.append(file)
            }
        }
        
        var groups: [FileGroup] = []
        if !today.isEmpty {
            groups.append(FileGroup(id: "today", title: "Today", files: today))
        }
        if !lastWeek.isEmpty {
            groups.append(FileGroup(id: "lastWeek", title: "Last week", files: lastWeek))
        }
        if !earlier.isEmpty {
            groups.append(FileGroup(id: "earlier", title: "Earlier", files: earlier))
        }
        return groups
    }
}
