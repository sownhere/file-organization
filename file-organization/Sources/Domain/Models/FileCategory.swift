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
        switch fileExtension.lowercased() {
        case "jpg", "jpeg", "png", "gif", "heic", "heif", "webp", "bmp":
                .image
        case "mp4", "mov", "m4v", "avi", "mkv":
                .video
        case "mp3", "wav", "m4a", "aac", "flac":
                .audio
        case "pdf", "doc", "docx", "txt", "md", "rtf",
            "xls", "xlsx", "ppt", "pptx", "pages", "numbers", "key":
                .document
        case "zip", "rar", "7z", "tar", "gz":
                .archive
        default:
                .other
        }
    }
}
