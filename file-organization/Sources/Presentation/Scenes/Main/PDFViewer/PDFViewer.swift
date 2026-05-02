//
//  PDFViewer.swift
//  file-organization
//
//  Created by sown on 4/15/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
import PDFKit

private nonisolated enum PDFViewerCancelID: Hashable, Sendable {
    case documentLoad(UUID)
}

@Reducer
struct PDFViewer {
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var file: FileItem
        var documentPresentation: DocumentPresentation = .pending
    }

    enum DocumentPresentation: Equatable, Sendable {
        case pending
        case loading
        case ready(URL)
        case failed(String)
    }

    // MARK: - Action
    enum Action {
        case task
        case documentLoaded(URL)
        case documentFailed(String)
    }

    // MARK: - Body
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .task:
                state.documentPresentation = .loading
                let file = state.file
                return .run { send in
                    await send(Self.resolvePresentation(for: file))
                }
                .cancellable(
                    id: PDFViewerCancelID.documentLoad(file.id),
                    cancelInFlight: true
                )

            case let .documentLoaded(url):
                state.documentPresentation = .ready(url)
                return .none

            case let .documentFailed(message):
                state.documentPresentation = .failed(message)
                return .none
            }
        }
    }
}

// MARK: - Private
private extension PDFViewer {
    static func resolvePresentation(for file: FileItem) async -> Action {
        do {
            let url = try file.resolvedDocumentsURL()
            guard FileManager.default.fileExists(atPath: url.path) else {
                return .documentFailed("File not found.")
            }
            guard PDFDocument(url: url) != nil else {
                return .documentFailed("Could not open this PDF.")
            }
            return .documentLoaded(url)
        } catch {
            return .documentFailed("Could not read the file.")
        }
    }
}
