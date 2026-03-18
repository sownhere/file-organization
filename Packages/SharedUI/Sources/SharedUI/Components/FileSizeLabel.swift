import Core
import SwiftUI

/// Displays a formatted file size with consistent styling.
public struct FileSizeLabel: View {
    private let bytes: Int64

    public init(bytes: Int64) {
        self.bytes = bytes
    }

    public var body: some View {
        Text(bytes.formattedFileSize)
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}
