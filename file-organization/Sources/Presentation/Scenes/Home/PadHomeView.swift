import ComposableArchitecture
import SwiftUI

/// iPad-optimized Home layout: sidebar + detail with wider content area.
struct PadHomeView: View {
    let store: StoreOf<Home>

    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detailContent
        }
    }

    private var sidebar: some View {
        List {
            Section("Categories") {
                Label("All Files", systemImage: "folder")
                Label("Images", systemImage: "photo")
                Label("Videos", systemImage: "film")
                Label("Documents", systemImage: "doc.text")
                Label("Audio", systemImage: "waveform")
                Label("Archives", systemImage: "archivebox")
            }

            Section("Quick Access") {
                Label("Recent", systemImage: "clock")
                Label("Favorites", systemImage: "star")
            }
        }
        .navigationTitle("File Organization")
    }

    private var detailContent: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.Colors.backgroundTop, AppTheme.Colors.backgroundBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("File Organization")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.Colors.primaryText)
                    Text("iPad layout - sidebar + detail view")
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .foregroundStyle(AppTheme.Colors.secondaryText)
                }

                VStack(spacing: 14) {
                    infoRow(title: "Display Name", value: AppConfig.App.displayName)
                    infoRow(title: "Bundle ID", value: AppConfig.App.bundleID)
                    infoRow(title: "Version", value: "\(AppConfig.App.version) (\(AppConfig.App.buildNumber))")
                    infoRow(title: "API", value: "\(AppConfig.API.domainURL)\(AppConfig.API.version)")
                    infoRow(title: "Layout", value: "Pad (regular)")
                }

                Label("Root -> Home flow is active", systemImage: "checkmark.circle.fill")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppTheme.Colors.accent)
            }
            .padding(28)
            .frame(maxWidth: 560, alignment: .leading)
            .background(AppTheme.Colors.cardBackground, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(AppTheme.Colors.secondaryAccent.opacity(0.14), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 24, y: 14)
            .padding(24)
        }
    }

    @ViewBuilder
    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.Colors.secondaryText)
                .frame(width: 96, alignment: .leading)

            Text(value)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.Colors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(Color.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
