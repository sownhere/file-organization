//
//  ShareRootViewController.swift
//  FileOrganizationShareExtension
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import Social
import UniformTypeIdentifiers

final class ShareRootViewController: SLComposeServiceViewController {
    private let inboxDirectoryName = "Inbox"
    private var supportedProviders: [NSItemProvider] = []
    private var unsupportedAttachmentCount = 0
    private var previewFileNames: [String] = []
    
    override func isContentValid() -> Bool {
        !supportedProviders.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSharePreview()
    }
    
    override func didSelectPost() {
        importAttachmentsToSharedInbox(providers: supportedProviders) { [weak self] in
            self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
    
    override func didSelectCancel() {
        extensionContext?.cancelRequest(withError: NSError(
            domain: "ShareRootViewController",
            code: NSUserCancelledError,
            userInfo: nil
        ))
    }
    
}

private extension ShareRootViewController {
    func configureSharePreview() {
        let allProviders = extensionItems()
            .flatMap { $0.attachments ?? [] }
        
        supportedProviders = allProviders.filter(isSupportedAttachmentProvider(_:))
        unsupportedAttachmentCount = max(0, allProviders.count - supportedProviders.count)
        previewFileNames = supportedProviders.map(displayName(for:))
        
        if supportedProviders.isEmpty {
            placeholder = "No compatible files found. Select files and try sharing again."
            return
        }
        
        placeholder = "\(importReadinessSummary()) • \(selectedFilesSummary())"
    }
    
    func extensionItems() -> [NSExtensionItem] {
        (extensionContext?.inputItems as? [NSExtensionItem]) ?? []
    }
    
    func importAttachmentsToSharedInbox(providers: [NSItemProvider], completion: @escaping () -> Void) {
        guard
            !providers.isEmpty,
            let sharedInboxURL = sharedInboxDirectoryURL()
        else {
            completion()
            return
        }

        let dispatchGroup = DispatchGroup()
        
        for provider in providers {
            dispatchGroup.enter()
            loadAndPersist(provider: provider, sharedInboxURL: sharedInboxURL) {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func sharedInboxDirectoryURL() -> URL? {
        let fileManager = FileManager.default
        guard let containerURL = fileManager.containerURL(
            forSecurityApplicationGroupIdentifier: ShareExtensionConfig.App.appGroupID
        ) else {
            return nil
        }
        
        let inboxURL = containerURL.appendingPathComponent(inboxDirectoryName, isDirectory: true)
        try? fileManager.createDirectory(at: inboxURL, withIntermediateDirectories: true)
        return inboxURL
    }
    
    func importReadinessSummary() -> String {
        var parts = ["\(supportedProviders.count) supported"]
        if unsupportedAttachmentCount > 0 {
            parts.append("\(unsupportedAttachmentCount) unsupported")
        }
        return parts.joined(separator: ", ")
    }
    
    func selectedFilesSummary() -> String {
        guard !previewFileNames.isEmpty else {
            return "No files"
        }
        
        if previewFileNames.count <= 3 {
            return previewFileNames.joined(separator: ", ")
        }
        
        let leading = previewFileNames.prefix(2).joined(separator: ", ")
        let remaining = previewFileNames.count - 2
        return "\(leading), +\(remaining) more"
    }
    
    func loadAndPersist(provider: NSItemProvider, sharedInboxURL: URL, completion: @escaping () -> Void) {
        let typeIdentifier: String = if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
            UTType.fileURL.identifier
        } else {
            UTType.data.identifier
        }
        
        provider.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { [weak self] item, _ in
            defer { completion() }
            guard let self else { return }
            
            if let url = item as? URL {
                copySourceFile(from: url, to: sharedInboxURL)
                return
            }
            
            if let data = item as? Data {
                let baseName = provider.suggestedName ?? UUID().uuidString
                let ext = preferredFileExtension(for: provider)
                let destination = self.uniqueDestinationURL(
                    in: sharedInboxURL,
                    preferredName: baseName,
                    fileExtension: ext
                )
                try? data.write(to: destination, options: .atomic)
            }
        }
    }
    
    func copySourceFile(from sourceURL: URL, to sharedInboxURL: URL) {
        let fileManager = FileManager.default
        let accessed = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if accessed {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }
        
        let destination = uniqueDestinationURL(
            in: sharedInboxURL,
            preferredName: sourceURL.deletingPathExtension().lastPathComponent,
            fileExtension: sourceURL.pathExtension
        )
        
        do {
            try fileManager.copyItem(at: sourceURL, to: destination)
        } catch {
            if let temporaryURL = try? duplicateToTemporaryFile(from: sourceURL),
               (try? fileManager.copyItem(at: temporaryURL, to: destination)) != nil {
                try? fileManager.removeItem(at: temporaryURL)
            }
        }
    }
    
    func uniqueDestinationURL(in directory: URL, preferredName: String, fileExtension: String) -> URL {
        let fileManager = FileManager.default
        let sanitizedName = preferredName.isEmpty ? UUID().uuidString : preferredName
        var candidate = directory.appendingPathComponent(sanitizedName)
        if !fileExtension.isEmpty {
            candidate = candidate.appendingPathExtension(fileExtension)
        }
        
        var index = 1
        while fileManager.fileExists(atPath: candidate.path) {
            var next = directory.appendingPathComponent("\(sanitizedName)-\(index)")
            if !fileExtension.isEmpty {
                next = next.appendingPathExtension(fileExtension)
            }
            candidate = next
            index += 1
        }
        
        return candidate
    }
    
    func duplicateToTemporaryFile(from sourceURL: URL) throws -> URL {
        let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let destination = uniqueDestinationURL(
            in: tempDirectory,
            preferredName: sourceURL.deletingPathExtension().lastPathComponent,
            fileExtension: sourceURL.pathExtension
        )
        try FileManager.default.copyItem(at: sourceURL, to: destination)
        return destination
    }
    
    nonisolated func preferredFileExtension(for provider: NSItemProvider) -> String {
        provider.registeredTypeIdentifiers
            .compactMap { UTType($0)?.preferredFilenameExtension }
            .first ?? "dat"
    }
    
    nonisolated func isSupportedAttachmentProvider(_ provider: NSItemProvider) -> Bool {
        provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) ||
        provider.hasItemConformingToTypeIdentifier(UTType.data.identifier)
    }
    
    nonisolated func displayName(for provider: NSItemProvider) -> String {
        let name = provider.suggestedName ?? "Untitled"
        let ext = preferredFileExtension(for: provider)
        if name.contains(".") || ext.isEmpty {
            return name
        }
        return "\(name).\(ext)"
    }
}
