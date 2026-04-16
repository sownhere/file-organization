//
//  Int64+FileSize.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import Foundation

extension Int64 {
    /// Formats byte count into human-readable string (e.g., "2.4 MB").
    public var formattedFileSize: String {
        ByteCountFormatter.string(fromByteCount: self, countStyle: .file)
    }
}
