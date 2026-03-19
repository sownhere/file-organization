//
//  MainTabItem.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import SwiftUI

enum MainTabItem: Int, Sendable, Equatable, Hashable, CaseIterable {
    case recents
    case myFiles
    case action
    case setting
    
    var tabItemTitle: String {
        switch self {
        case .recents: "Recents"
        case .myFiles: "My Files"
        case .action: "Action"
        case .setting: "Setting"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .recents: "clock"
        case .myFiles: "folder"
        case .action: "square.grid.2x2"
        case .setting: "gearshape"
        }
    }
    
    var selectedSystemImageName: String {
        switch self {
        case .recents: "clock.fill"
        case .myFiles: "folder.fill"
        case .action: "square.grid.2x2.fill"
        case .setting: "gearshape.fill"
        }
    }
    
    func icon(_ isSelected: Bool) -> Image {
        Image(systemName: isSelected ? selectedSystemImageName : systemImageName)
    }
}
