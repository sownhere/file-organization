import Core
import Foundation
import UniformTypeIdentifiers

/// Determines the category of a file based on its extension or UTType.
public enum FileCategorizer {
    public static func categorize(fileExtension ext: String) -> FileCategory {
        guard let utType = UTType(filenameExtension: ext) else {
            return .other
        }
        return categorize(utType: utType)
    }

    public static func categorize(utType: UTType) -> FileCategory {
        if utType.conforms(to: .image) { return .image }
        if utType.conforms(to: .movie) || utType.conforms(to: .video) { return .video }
        if utType.conforms(to: .audio) { return .audio }
        if utType.conforms(to: .archive) || utType.conforms(to: .zip) { return .archive }
        if utType.conforms(to: .pdf)
            || utType.conforms(to: .text)
            || utType.conforms(to: .spreadsheet)
            || utType.conforms(to: .presentation) { return .document }
        return .other
    }
}
