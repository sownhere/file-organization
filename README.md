# File Organization

A native iOS file management app built with **SwiftUI** and **The Composable Architecture (TCA)**.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **UI** | SwiftUI (iOS 18+) |
| **Architecture** | TCA (The Composable Architecture) v1.25.1 + Clean Architecture |
| **Language** | Swift 6.0 |
| **State Management** | Unidirectional data flow (Store → Reducer → Effect) |
| **Code Quality** | SwiftLint (custom rules) |
| **Automation** | fastlane |
| **Platforms** | iOS 18, macOS 15 |

## Project Structure

```
file-organization/
├── Sources/
│   ├── Application/                    # App entry point, delegates, config
│   │   ├── FileOrganizationApp.swift   # @main entry
│   │   ├── AppConfig.swift             # Info.plist config reader
│   │   └── AppDelegate/               # UIKit lifecycle bridge
│   ├── Domain/                         # Business logic & data layer
│   │   └── Client/                     # TCA Dependencies (API/Service clients)
│   └── Presentation/                   # UI layer
│       ├── Common/
│       │   └── Styles/AppTheme.swift   # Colors & theming
│       ├── Shared/
│       │   └── AdaptiveView.swift      # iPhone/iPad responsive wrapper
│       └── Scenes/
│           ├── Root/                   # App root (destination routing)
│           ├── MainNavigation/         # NavigationStack + Path routing
│           ├── MainTab/                # TabView + custom tab bar
│           └── Recents/                # Recents screen (grid/list view)
│
├── Packages/                           # Local SPM modules
│   ├── Core/                           # Domain models (FileItem, FileCategory, SortOption)
│   ├── FileServices/                   # File categorization & App Group storage
│   └── SharedUI/                       # Reusable UI components (FileIconView, CardStyle)
│
├── swift-rules/                        # iOS development rules & templates
│   ├── rules/swiftui.md               # SwiftUI + TCA coding standards
│   └── templates/swiftui/             # Feature, View, Model, Client templates
│
├── .github/                            # GitHub templates, hooks, workflows
├── fastlane/                           # iOS automation
├── envs/                               # Environment configurations
└── test-plan/                          # Config tests plan for the app
```

## Architecture

The app follows TCA's unidirectional data flow pattern:

```
Root
 └── MainNavigation          (NavigationStack with StackState<Path>)
      └── MainTab             (TabView: Recents | My Files | Action | Setting)
           └── Recents        (File browser with grid/list toggle)
```

### Navigation Pattern

- **`MainNavigation`** — Wraps the entire app in a `NavigationStack(path:root:destination:)`. All push navigation is handled here via `StackState<Path>`.
- **`MainTab`** — Manages tab selection and scopes child reducers for each tab.
- **Child features** communicate to parents via `delegate` actions (never direct parent mutation).

### Key Conventions

- Each scene has a **Reducer** (`SceneName.swift`) and a **View** (`SceneNameView.swift`)
- `@preconcurrency import ComposableArchitecture` for Swift 6 compatibility
- `@Bindable var store` in views for two-way bindings
- Delegate pattern for child-to-parent communication
- Private extensions for helper methods on reducers

## Build Configurations

| Scheme | Configuration | Use |
|--------|--------------|-----|
| `file-organization Dev` | Dev Debug / Dev Release | Development |
| `file-organization Staging` | Staging Debug / Staging Release | QA / Testing |
| `file-organization Production` | Production Debug / Production Release | App Store |

API and environment values are injected via `Info.plist` per configuration.

## Getting Started

### Prerequisites

- Xcode 16+ (Swift 6.0)
- iOS 18.0+ deployment target
- SwiftLint (`brew install swiftlint`)

### Build & Run

```bash
# Open in Xcode
open file-organization.xcodeproj

# Or build from command line
xcodebuild -scheme "file-organization Dev" \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  build
```

### Cursor SourceKit + SPM Index Setup

When cloning the repo on a new machine, run this once so app, tests, and share extension are all indexed in the same `@build` data:

```bash
# Build app + tests + share extension into @build and refresh buildServer.json
./scripts/index-all.sh
```

Optional: pass a custom simulator destination:

```bash
./scripts/index-all.sh "platform=iOS Simulator,name=iPhone 17"
```

If test sources currently fail to compile, the script continues after printing a warning so app and extension index data still get refreshed.

If Cursor still shows stale module errors after script completion, run `Developer: Reload Window`.

### Code Generation

Use the `swift-rules` templates to scaffold new features:

```bash
# See available templates
ls swift-rules/templates/swiftui/

# Templates: feature.swift, view.swift, model.swift, client.swift,
#            repository.swift, component.swift, test.swift
```

## Development Rules

All code must follow `swift-rules/rules/swiftui.md`. Key points:

- **Naming**: UpperCamelCase types, lowerCamelCase properties, no abbreviations
- **Access Control**: Default to `private`, use `private(set)` for read-only
- **Optionals**: Never force unwrap, use `guard let` / `if let` / `??`
- **SwiftUI**: Native components first, `@ViewBuilder` for subviews, stable `ForEach` identity
- **TCA**: Share logic via methods (not extra actions), debounce search, cancel effects on removal
- **Concurrency**: Start single-threaded, add async only when profiling proves it's needed
- **SwiftLint**: All opt-in rules enabled, identifier min 3 chars, max 120 line length

## License

Private repository. All rights reserved.
