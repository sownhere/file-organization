#!/usr/bin/env bash
set -euo pipefail

PROJECT="file-organization.xcodeproj"
APP_SCHEME="file-organization Dev"
EXTENSION_SCHEME="FileOrganizationShareExtension"
DESTINATION="${1:-platform=iOS Simulator,name=iPhone 17 Pro}"
DERIVED_DATA_PATH="@build"
MODULE_CACHE_PATH="$DERIVED_DATA_PATH/ModuleCache.noindex"
SWIFT_EXPLICIT_MODULES_PATH="$DERIVED_DATA_PATH/Build/Intermediates.noindex/SwiftExplicitPrecompiledModules"

echo "==> Resolving Swift packages"
xcodebuild -resolvePackageDependencies -project "$PROJECT"

echo "==> Resetting module caches to avoid dependency scanner variant conflicts"
rm -rf "$MODULE_CACHE_PATH" "$SWIFT_EXPLICIT_MODULES_PATH"
mkdir -p "$MODULE_CACHE_PATH"

echo "==> Building app + test targets into $DERIVED_DATA_PATH"
if ! CLANG_MODULE_CACHE_PATH="$MODULE_CACHE_PATH" SWIFT_MODULE_CACHE_PATH="$MODULE_CACHE_PATH" xcodebuild build-for-testing \
  -project "$PROJECT" \
  -scheme "$APP_SCHEME" \
  -destination "$DESTINATION" \
  -derivedDataPath "$DERIVED_DATA_PATH"; then
  echo "WARNING: build-for-testing failed. App index data was generated, but test targets may be partially indexed."
fi

echo "==> Building share extension into $DERIVED_DATA_PATH"
CLANG_MODULE_CACHE_PATH="$MODULE_CACHE_PATH" SWIFT_MODULE_CACHE_PATH="$MODULE_CACHE_PATH" xcodebuild build \
  -project "$PROJECT" \
  -scheme "$EXTENSION_SCHEME" \
  -destination "$DESTINATION" \
  -derivedDataPath "$DERIVED_DATA_PATH"

echo "Done. If Cursor still shows stale diagnostics, run: Developer: Reload Window"
