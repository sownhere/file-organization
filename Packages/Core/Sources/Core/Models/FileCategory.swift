import Foundation

/// Categories for organizing files by type.
public enum FileCategory: String, Sendable, Equatable, Hashable, Codable, CaseIterable {
    case image
    case video
    case audio
    case document
    case archive
    case other

    public var displayName: String {
        switch self {
        case .image: "Images"
        case .video: "Videos"
        case .audio: "Audio"
        case .document: "Documents"
        case .archive: "Archives"
        case .other: "Other"
        }
    }

    public var systemIcon: String {
        switch self {
        case .image: "photo"
        case .video: "film"
        case .audio: "waveform"
        case .document: "doc.text"
        case .archive: "archivebox"
        case .other: "questionmark.folder"
        }
    }
}
