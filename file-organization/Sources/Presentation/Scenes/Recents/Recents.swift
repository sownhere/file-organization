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
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case reload
        case filesLoaded([FileItem])
        case loadFailed
        case toggleViewMode
        case toggleSelectionMode
        case toggleFileSelection(UUID)
        case searchTapped
        case fileTapped(FileItem)
        case fileMenuTapped(FileItem)
        case fabTapped
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
        BindingReducer()
        
        Reduce { state, action in
            switch action {
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
                .cancellable(id: RecentsCancelID.load, cancelInFlight: true)
                
            case let .filesLoaded(files):
                let sorted = files.sorted { $0.createdAt > $1.createdAt }
                state.groupedFiles = FileGroup.group(
                    files: sorted,
                    relativeTo: now,
                    calendar: calendar
                )
                return .none
                
            case .loadFailed:
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
                
            case .searchTapped,
                    .fileTapped,
                    .fileMenuTapped,
                    .fabTapped:
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
