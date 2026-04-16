//
//  AdaptiveView.swift
//  Shared
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

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
struct AdaptiveView<IPhoneContent: View, IPadContent: View>: View {
    @Environment(\.horizontalSizeClass)
    private var sizeClass
    
    let phone: () -> IPhoneContent
    let pad: () -> IPadContent
    
    init(
        @ViewBuilder phone: @escaping () -> IPhoneContent,
        @ViewBuilder pad: @escaping () -> IPadContent
    ) {
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
