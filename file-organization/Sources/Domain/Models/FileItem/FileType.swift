//
//  FileType.swift
//  file-organization
//
//  Created by sown on 4/17/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import Foundation

/// File types the app recognizes, keyed by filename extension (lowercase, no dot).
/// Maps to ``FileCategory`` via ``category``.
public enum FileType: String, Sendable, CaseIterable {
    // MARK: Image
    case jpg
    case jpeg
    case png
    case gif
    case heic
    case heif
    case webp
    case bmp

    // MARK: Video
    case mp4
    case mov
    case m4v
    case avi
    case mkv

    // MARK: Audio
    case mp3
    case wav
    case m4a
    case aac
    case flac

    // MARK: Document
    case pdf
    case doc
    case docx
    case txt
    // swiftlint:disable:next identifier_name
    case md
    case rtf
    case xls
    case xlsx
    case ppt
    case pptx
    case pages
    case numbers
    case key

    // MARK: Archive
    case zip
    case rar
    case sevenZip = "7z"
    case tar
    // swiftlint:disable:next identifier_name
    case gz

    /// Category for this file type.
    nonisolated public var category: FileCategory {
        switch self {
        case .jpg, .jpeg, .png, .gif, .heic, .heif, .webp, .bmp:
            .image
        case .mp4, .mov, .m4v, .avi, .mkv:
            .video
        case .mp3, .wav, .m4a, .aac, .flac:
            .audio
        case .pdf, .doc, .docx, .txt, .md, .rtf, .xls, .xlsx, .ppt, .pptx, .pages, .numbers, .key:
            .document
        case .zip, .rar, .sevenZip, .tar, .gz:
            .archive
        }
    }

    /// Parses a filename extension (any casing; leading `.` is ignored) into a known ``FileType``.
    nonisolated public static func parse(fileExtension: String) -> FileType? {
        let normalized = fileExtension
            .lowercased()
            .trimmingCharacters(in: .init(charactersIn: "."))
        return FileType(rawValue: normalized)
    }

    /// File types grouped by category (derived from ``category`` — single source of truth).
    public static let imageExtensions: Set<FileType> = Set(
        allCases.filter { $0.category == .image }
    )
    public static let videoExtensions: Set<FileType> = Set(
        allCases.filter { $0.category == .video }
    )
    public static let audioExtensions: Set<FileType> = Set(
        allCases.filter { $0.category == .audio }
    )
    public static let documentExtensions: Set<FileType> = Set(
        allCases.filter { $0.category == .document }
    )
    public static let archiveExtensions: Set<FileType> = Set(
        allCases.filter { $0.category == .archive }
    )

    /// Returns the ``FileCategory`` for a file extension (with or without leading dot, any casing).
    nonisolated public static func category(forFileExtension fileExtension: String) -> FileCategory {
        parse(fileExtension: fileExtension)?.category ?? .other
    }
}
