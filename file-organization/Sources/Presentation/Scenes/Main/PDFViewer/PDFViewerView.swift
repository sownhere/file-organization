//
//  PDFViewerView.swift
//  file-organization
//
//  Created by sown on 4/15/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
import PDFKit
import SwiftUI

struct PDFViewerView: View {
    @Bindable var store: StoreOf<PDFViewer>
    
    var body: some View {
        content
            .navigationTitle(store.file.fullName)
            .navigationBarTitleDisplayMode(.inline)
            .task(id: store.file.id) {
                store.send(.task)
            }
    }
}

private extension PDFViewerView {
    @ViewBuilder var content: some View {
        switch store.documentPresentation {
        case .pending, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case let .ready(url):
            PDFKitRepresentable(documentURL: url)
                .ignoresSafeArea(edges: .bottom)

        case let .failed(message):
            EmptyView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .modifier(PDFDocumentUnavailableModifier(message: message))
        }
    }
}

// MARK: - PDF document unavailable (presentation)

private struct PDFDocumentUnavailableModifier: ViewModifier {
    let message: String

    func body(content: Content) -> some View {
        content
            .overlay {
                ContentUnavailableView(
                    "Unable to display PDF",
                    systemImage: "doc.text.fill",
                    description: Text(message)
                )
            }
    }
}

// MARK: - PDFKitRepresentable

private struct PDFKitRepresentable: UIViewRepresentable {
    let documentURL: URL

    final class Coordinator: NSObject {
        var loadedURL: URL?
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        configure(pdfView)
        context.coordinator.loadedURL = documentURL
        pdfView.document = PDFDocument(url: documentURL)
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        if context.coordinator.loadedURL != documentURL {
            context.coordinator.loadedURL = documentURL
            pdfView.document = PDFDocument(url: documentURL)
        }
    }

    private func configure(_ pdfView: PDFView) {
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.usePageViewController(false)
    }
}
