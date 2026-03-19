//
//  MyFilesView.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
import SwiftUI

struct MyFilesView: View {
    // MARK: - Store
    @Bindable var store: StoreOf<MyFiles>
    
    private let gridColumns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 3
    )
    
    var body: some View {
        content
            .navigationTitle("My Files")
            .navigationBarTitleDisplayMode(.large)
            .onAppear { store.send(.onAppear) }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.toggleViewMode)
                    } label: {
                        Image(systemName: store.viewMode == .grid ? "list.bullet" : "square.grid.2x2")
                            .foregroundStyle(.primary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort", selection: $store.sort) {
                            ForEach(MyFiles.Sort.allCases, id: \.self) { option in
                                Text(option.displayName).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundStyle(.primary)
                    }
                }
            }
    }
}

private extension MyFilesView {
    @ViewBuilder var content: some View {
        ScrollView {
            if store.files.isEmpty {
                emptyState
            } else {
                fileContent
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "folder")
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
    
    @ViewBuilder var fileContent: some View {
        LazyVStack(alignment: .leading, spacing: 6) {
            switch store.viewMode {
            case .grid:
                LazyVGrid(columns: gridColumns, spacing: 8) {
                    ForEach(store.files) { file in
                        fileGridItem(file)
                    }
                }
                .padding(.horizontal, 16)
            case .list:
                VStack(spacing: 10) {
                    ForEach(store.files) { file in
                        fileListItem(file)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 100)
        .padding(.top, 6)
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
            
            Text(dateLabel(for: file).formatted(.dateTime.month().day().year()))
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
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
                
                Text(dateLabel(for: file).formatted(.dateTime.month().day().year()))
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
    
    func dateLabel(for file: FileItem) -> Date {
        switch store.sort {
        case .dateAdded: file.createdAt
        case .dateModified: file.modifiedAt
        }
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
