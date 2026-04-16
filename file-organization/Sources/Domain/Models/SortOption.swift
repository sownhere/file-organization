//
//  SortOption.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import Foundation

public enum SortOption: String, Sendable, Equatable, Hashable, CaseIterable {
    case name
    case date
    case size
    case type
    
    public var displayName: String {
        switch self {
        case .name: "Name"
        case .date: "Date"
        case .size: "Size"
        case .type: "Type"
        }
    }
}
