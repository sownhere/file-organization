//
//  FileItem+FileType.swift
//  file-organization
//
//  Created by sown on 4/17/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import Foundation

extension FileItem {
    /// Recognized ``FileType`` for this item’s extension, if the app models it.
    public var fileType: FileType? {
        FileType.parse(fileExtension: fileExtension)
    }
}
