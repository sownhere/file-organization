//
//  RecentsView.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
import SwiftUI

struct RecentsView: View {
    // MARK: - Store
    @Bindable var store: StoreOf<Recents>
    
    // MARK: - Properties
    private let gridColumns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 3
    )
    
    // MARK: - Body
    var body: some View {
        content
            .navigationTitle("Recents")
            .navigationBarTitleDisplayMode(.large)
            .onAppear { store.send(.onAppear) }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.searchTapped)
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.primary)
                    }
                }
            }
    }
}

// MARK: - Content
private extension RecentsView {
    @ViewBuilder var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                toolbar
                if store.groupedFiles.isEmpty {
                    emptyState
                } else {
                    fileContent
                }
            }
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("No files yet")
                .font(.system(size: 17, weight: .semibold))
            Text("In Safari tap Share → Save to Files → file-organization.")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
    
    // MARK: - Toolbar
    @ViewBuilder var toolbar: some View {
        HStack {
            Spacer()
            HStack(spacing: 8) {
                Button {
                    store.send(.toggleViewMode)
                } label: {
                    Image(systemName: store.viewMode == .grid ? "list.bullet" : "square.grid.2x2")
                        .font(.system(size: 20))
                        .foregroundStyle(.primary)
                }
                
                Button {
                    store.send(.toggleSelectionMode)
                } label: {
                    Image(systemName: store.isSelectionMode ? "checkmark.square.fill" : "checkmark.square")
                        .font(.system(size: 20))
                        .foregroundStyle(store.isSelectionMode ? AppTheme.Colors.accent : .primary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    // MARK: - File Content
    @ViewBuilder var fileContent: some View {
        LazyVStack(alignment: .leading, spacing: 6) {
            ForEach(store.groupedFiles) { group in
                dateHeader(group.title)
                
                switch store.viewMode {
                case .grid:
                    fileGrid(files: group.files)
                case .list:
                    fileList(files: group.files)
                }
            }
        }
    }
    
    @ViewBuilder
    func dateHeader(_ title: String) -> some View {
        HStack {
            Spacer()
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Grid View
    @ViewBuilder
    func fileGrid(files: [FileItem]) -> some View {
        LazyVGrid(columns: gridColumns, spacing: 8) {
            ForEach(files) { file in
                fileGridItem(file)
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func fileGridItem(_ file: FileItem) -> some View {
        VStack(spacing: 0) {
            Button {
                store.send(.fileTapped(file))
            } label: {
                Image(systemName: file.category.systemIcon)
                    .font(.system(size: 48))
                    .foregroundStyle(iconColor(for: file.category))
                    .frame(width: 100, height: 100)
            }
            
            Text(file.fullName)
                .font(.system(size: 13))
                .foregroundStyle(.primary)
                .lineLimit(1)
            
            Text(file.modifiedAt.formatted(.dateTime.month().day().year()))
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
            
            HStack {
                Text("\(pageCount(for: file)) pages")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                
                Spacer()
                fileMenu(for: file)
            }
        }
        .padding(10)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
    
    // MARK: - List View
    @ViewBuilder
    func fileList(files: [FileItem]) -> some View {
        VStack(spacing: 10) {
            ForEach(files) { file in
                fileListItem(file)
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func fileListItem(_ file: FileItem) -> some View {
        HStack(spacing: 0) {
            Button {
                store.send(.fileTapped(file))
            } label: {
                Image(systemName: file.category.systemIcon)
                    .font(.system(size: 30))
                    .foregroundStyle(iconColor(for: file.category))
                    .frame(width: 62, height: 62)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(file.fullName)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 10) {
                    Text(file.modifiedAt.formatted(.dateTime.month().day().year()))
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    
                    Divider()
                        .frame(height: 12)
                    
                    Text("\(pageCount(for: file)) pages")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .bottom) {
                Divider()
            }
            
            fileMenu(for: file)
        }
        .padding(10)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
    
    // MARK: - Shared Components
    @ViewBuilder
    func fileMenu(for file: FileItem) -> some View {
        Menu {
            Button("Share", systemImage: "square.and.arrow.up") {}
            Button("Rename", systemImage: "pencil") {}
            Button("Delete", systemImage: "trash", role: .destructive) {}
        } label: {
            Image(systemName: store.viewMode == .grid ? "ellipsis" : "ellipsis.vertical")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.secondary)
                .frame(width: 24, height: 24)
        }
    }
    
    // MARK: - Helpers
    func pageCount(for file: FileItem) -> Int {
        max(1, Int(file.size / (1024 * 256)))
    }
    
    func iconColor(for category: FileCategory) -> Color {
        switch category {
        case .image: .blue
        case .video: .purple
        case .audio: .orange
        case .document: .red
        case .archive: .gray
        case .other: .secondary
        }
    }
}
