//
//  FileItem+ResolvedURL.swift
//  file-organization
//
//  Created by sown on 4/17/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import Foundation

extension FileItem {
    /// Resolves the file URL in the app Documents directory (same layout as `FileStorageClient`).
    public func resolvedDocumentsURL() throws -> URL {
        let fileManager = FileManager.default
        let documents = try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        return documents.appendingPathComponent(relativePath)
    }
}
