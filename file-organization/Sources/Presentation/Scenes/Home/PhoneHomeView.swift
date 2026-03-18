import ComposableArchitecture
import SwiftUI

/// iPhone-optimized Home layout: tab-based navigation with list view.
struct PhoneHomeView: View {
    let store: StoreOf<Home>

    var body: some View {
        NavigationStack {
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
                        Text("iPhone layout - compact view")
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .foregroundStyle(AppTheme.Colors.secondaryText)
                    }

                    VStack(spacing: 14) {
                        infoRow(title: "Display Name", value: AppConfig.App.displayName)
                        infoRow(title: "Bundle ID", value: AppConfig.App.bundleID)
                        infoRow(title: "Version", value: "\(AppConfig.App.version) (\(AppConfig.App.buildNumber))")
                        infoRow(title: "API", value: "\(AppConfig.API.domainURL)\(AppConfig.API.version)")
                        infoRow(title: "Layout", value: "Phone (compact)")
                    }

                    Label("Root -> Home flow is active", systemImage: "checkmark.circle.fill")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(AppTheme.Colors.accent)
                }
                .padding(28)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.Colors.cardBackground, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(AppTheme.Colors.secondaryAccent.opacity(0.14), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 24, y: 14)
                .padding(24)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
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
