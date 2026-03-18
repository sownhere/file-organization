import SwiftUI

/// Routes to iPhone or iPad specific views based on horizontal size class.
///
/// Usage:
/// ```
/// AdaptiveView {
///     PhoneHomeView(store: store)
/// } pad: {
///     PadHomeView(store: store)
/// }
/// ```
struct AdaptiveView<PhoneContent: View, PadContent: View>: View {
    @Environment(\.horizontalSizeClass)
    private var sizeClass

    let phone: () -> PhoneContent
    let pad: () -> PadContent

    init(@ViewBuilder phone: @escaping () -> PhoneContent, @ViewBuilder pad: @escaping () -> PadContent) {
        self.phone = phone
        self.pad = pad
    }

    var body: some View {
        if sizeClass == .compact {
            phone()
        } else {
            pad()
        }
    }
}
