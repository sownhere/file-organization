import Foundation

extension Int64 {
    /// Formats byte count into human-readable string (e.g., "2.4 MB").
    public var formattedFileSize: String {
        ByteCountFormatter.string(fromByteCount: self, countStyle: .file)
    }
}
