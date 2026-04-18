//
//  FileItem.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import Foundation

public struct FileItem: Sendable, Equatable, Hashable, Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let fileExtension: String
    public let category: FileCategory
    public let size: Int64
    public let createdAt: Date
    public let modifiedAt: Date
    public let relativePath: String
    
    nonisolated public init(
        id: UUID = UUID(),
        name: String,
        fileExtension: String,
        category: FileCategory,
        size: Int64,
        createdAt: Date = Date(),
        modifiedAt: Date = Date(),
        relativePath: String
    ) {
        self.id = id
        self.name = name
        self.fileExtension = fileExtension
        self.category = category
        self.size = size
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.relativePath = relativePath
    }
    
    nonisolated public var fullName: String {
        fileExtension.isEmpty ? name : "\(name).\(fileExtension)"
    }
}
