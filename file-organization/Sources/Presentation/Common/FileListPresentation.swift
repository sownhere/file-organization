//
//  FileListPresentation.swift
//  file-organization
//
//  Created by sown on 4/19/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import Foundation

enum FileListPresentation: Equatable, Sendable {
    case pending
    case loading
    case ready
    case failed(String)
}
