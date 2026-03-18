import SwiftUI

public struct CardStyleModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(.separator.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
    }
}

extension View {
    public func cardStyle() -> some View {
        modifier(CardStyleModifier())
    }
}
