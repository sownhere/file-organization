//
//  FileCategory.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import Foundation

/// Categories for organizing files by type.
public enum FileCategory: String, Sendable, Equatable, Hashable, Codable, CaseIterable {
    case image
    case video
    case audio
    case document
    case archive
    case other
    
    nonisolated public var displayName: String {
        switch self {
        case .image: "Images"
        case .video: "Videos"
        case .audio: "Audio"
        case .document: "Documents"
        case .archive: "Archives"
        case .other: "Other"
        }
    }
    
    nonisolated public var systemIcon: String {
        switch self {
        case .image: "photo"
        case .video: "film"
        case .audio: "waveform"
        case .document: "doc.text"
        case .archive: "archivebox"
        case .other: "questionmark.folder"
        }
    }
    
    nonisolated public static func from(fileExtension: String) -> FileCategory {
        FileType.category(forFileExtension: fileExtension)
    }
}
