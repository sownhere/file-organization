//
//  AppTheme.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import SwiftUI
import UIKit

enum AppTheme {
    enum Colors {
        static let backgroundTop = Color(red: 0.95, green: 0.98, blue: 1.0)
        static let backgroundBottom = Color(red: 0.88, green: 0.93, blue: 0.99)
        static let cardBackground = Color.white.opacity(0.82)
        static let accent = Color(red: 0.11, green: 0.44, blue: 0.91)
        static let secondaryAccent = Color(red: 0.16, green: 0.68, blue: 0.73)
        static let primaryText = Color(red: 0.08, green: 0.13, blue: 0.21)
        static let secondaryText = Color(red: 0.31, green: 0.39, blue: 0.49)
    }
    
    enum UIKitColors {
        static let navigationBackground = UIColor.systemBackground
        static let tabBarBackground = UIColor.systemBackground
        static let primaryText = UIColor.label
        static let separator = UIColor.separator.withAlphaComponent(0.12)
    }
}
