//
//  SharedImportItem.swift
//  FileOrganizationShareExtension
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers

struct SharedImportItem: Equatable {
    let fileURL: URL
    let contentType: UTType?
}
