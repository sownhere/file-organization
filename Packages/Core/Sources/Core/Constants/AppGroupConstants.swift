import Foundation

public enum AppGroupConstants {
    /// App Group identifier shared between main app and extensions.
    /// Update this value with your actual App Group ID from Apple Developer portal.
    public static let groupIdentifier = "group.com.santaris.file-organization"

    /// Key for shared UserDefaults
    public enum UserDefaultsKey {
        public static let recentFiles = "recentFiles"
        public static let totalFileCount = "totalFileCount"
        public static let lastSyncDate = "lastSyncDate"
    }
}
