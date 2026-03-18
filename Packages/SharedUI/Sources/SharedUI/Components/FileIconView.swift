import Core
import SwiftUI

/// Displays an icon for a file category with consistent styling.
public struct FileIconView: View {
    private let category: FileCategory
    private let size: CGFloat

    public init(category: FileCategory, size: CGFloat = 24) {
        self.category = category
        self.size = size
    }

    public var body: some View {
        Image(systemName: category.systemIcon)
            .font(.system(size: size))
            .foregroundStyle(color)
    }

    private var color: Color {
        switch category {
        case .image: .blue
        case .video: .purple
        case .audio: .orange
        case .document: .red
        case .archive: .gray
        case .other: .secondary
        }
    }
}
