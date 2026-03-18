import Core
import Foundation

/// Provides access to the App Group shared container for data sharing
/// between the main app and extensions (Widget, Shortcuts, Share, etc.).
public enum AppGroupStorage {
    public static var containerURL: URL? {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: AppGroupConstants.groupIdentifier
        )
    }

    public static var userDefaults: UserDefaults? {
        UserDefaults(suiteName: AppGroupConstants.groupIdentifier)
    }

    /// Returns the URL for a subdirectory within the shared container.
    /// Creates the directory if it doesn't exist.
    public static func directoryURL(for category: FileCategory) -> URL? {
        guard let containerURL else { return nil }
        let url = containerURL.appendingPathComponent(category.rawValue, isDirectory: true)
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }
}
