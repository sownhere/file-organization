//
//  FileStorageClient.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
import Foundation

@DependencyClient
nonisolated struct FileStorageClient: Sendable {
    var load: @Sendable () throws -> [FileItem]
    var delete: @Sendable (_ file: FileItem) throws -> Void
}

extension FileStorageClient: DependencyKey {
    static let liveValue: FileStorageClient = {
        let appGroupID = "group.com.santaris.fileorganization"
        let inboxDirectoryName = "Inbox"
        let keys: [URLResourceKey] = [
            .creationDateKey,
            .contentModificationDateKey,
            .fileSizeKey,
            .isDirectoryKey
        ]
        
        return FileStorageClient(
            load: {
                let fileManager = FileManager.default
                let documents = try fileManager.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                )
                moveSharedInboxFilesToDocuments(
                    fileManager: fileManager,
                    appGroupID: appGroupID,
                    inboxDirectoryName: inboxDirectoryName,
                    documentsURL: documents
                )
                
                let urls = try fileManager.contentsOfDirectory(
                    at: documents,
                    includingPropertiesForKeys: keys,
                    options: [.skipsHiddenFiles]
                )
                
                return urls.compactMap { url -> FileItem? in
                    let values = try? url.resourceValues(forKeys: Set(keys))
                    if values?.isDirectory == true { return nil }
                    
                    let created = values?.creationDate ?? Date()
                    let modified = values?.contentModificationDate ?? created
                    let size = Int64(values?.fileSize ?? 0)
                    let ext = url.pathExtension
                    
                    return FileItem(
                        name: url.deletingPathExtension().lastPathComponent,
                        fileExtension: ext,
                        category: FileCategory.from(fileExtension: ext),
                        size: size,
                        createdAt: created,
                        modifiedAt: modified,
                        relativePath: url.lastPathComponent
                    )
                }
            },
            delete: { file in
                let fileManager = FileManager.default
                let documents = try fileManager.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                )
                let url = documents.appendingPathComponent(file.relativePath)
                try fileManager.removeItem(at: url)
            }
        )
    }()
    
    static let testValue = FileStorageClient()
    
    static let previewValue = FileStorageClient(
        load: {
            let now = Date()
            return [
                FileItem(
                    name: "Sample",
                    fileExtension: "pdf",
                    category: .document,
                    size: 512_000,
                    createdAt: now,
                    modifiedAt: now,
                    relativePath: "Sample.pdf"
                )
            ]
        },
        delete: { _ in }
    )
}

extension DependencyValues {
    var fileStorageClient: FileStorageClient {
        get { self[FileStorageClient.self] }
        set { self[FileStorageClient.self] = newValue }
    }
}

nonisolated private func moveSharedInboxFilesToDocuments(
    fileManager: FileManager,
    appGroupID: String,
    inboxDirectoryName: String,
    documentsURL: URL
) {
    guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
        return
    }
    
    let inboxURL = groupURL.appendingPathComponent(inboxDirectoryName, isDirectory: true)
    guard let inboxFiles = try? fileManager.contentsOfDirectory(
        at: inboxURL,
        includingPropertiesForKeys: [.isDirectoryKey],
        options: [.skipsHiddenFiles]
    ) else {
        return
    }
    
    for sourceURL in inboxFiles {
        let values = try? sourceURL.resourceValues(forKeys: [.isDirectoryKey])
        if values?.isDirectory == true {
            continue
        }
        
        let destinationURL = uniqueFileURL(
            in: documentsURL,
            preferredName: sourceURL.deletingPathExtension().lastPathComponent,
            fileExtension: sourceURL.pathExtension,
            fileManager: fileManager
        )
        
        do {
            try fileManager.moveItem(at: sourceURL, to: destinationURL)
        } catch {
            if let data = try? Data(contentsOf: sourceURL),
               (try? data.write(to: destinationURL, options: .atomic)) != nil {
                try? fileManager.removeItem(at: sourceURL)
            }
        }
    }
}

nonisolated private func uniqueFileURL(
    in directory: URL,
    preferredName: String,
    fileExtension: String,
    fileManager: FileManager
) -> URL {
    let baseName = preferredName.isEmpty ? UUID().uuidString : preferredName
    var candidate = directory.appendingPathComponent(baseName)
    if !fileExtension.isEmpty {
        candidate = candidate.appendingPathExtension(fileExtension)
    }
    
    var index = 1
    while fileManager.fileExists(atPath: candidate.path) {
        var next = directory.appendingPathComponent("\(baseName)-\(index)")
        if !fileExtension.isEmpty {
            next = next.appendingPathExtension(fileExtension)
        }
        candidate = next
        index += 1
    }
    
    return candidate
}
