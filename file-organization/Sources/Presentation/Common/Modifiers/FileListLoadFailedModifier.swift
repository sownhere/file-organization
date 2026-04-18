//
//  FileListLoadFailedModifier.swift
//  file-organization
//
//  Created by sown on 4/19/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import SwiftUI

struct FileListLoadFailedModifier: ViewModifier {
    let title: String
    let systemImageName: String
    let message: String

    func body(content: Content) -> some View {
        content
            .overlay {
                ContentUnavailableView(
                    title,
                    systemImage: systemImageName,
                    description: Text(message)
                )
            }
    }
}

extension FileListLoadFailedModifier {
    static func unableToLoadFiles(message: String) -> Self {
        Self(
            title: "Unable to load files",
            systemImageName: "folder.badge.questionmark",
            message: message
        )
    }

    static func unableToLoadRecents(message: String) -> Self {
        Self(
            title: "Unable to load recents",
            systemImageName: "exclamationmark.triangle",
            message: message
        )
    }
}

extension View {
    func unableToLoadFiles(message: String) -> some View {
        modifier(FileListLoadFailedModifier.unableToLoadFiles(message: message))
    }
}

extension View {
    func unableToLoadRecents(message: String) -> some View {
        modifier(FileListLoadFailedModifier.unableToLoadRecents(message: message))
    }
}
