# Repository Guidelines

## Project Structure & Module Organization

This is an Xcode SwiftUI app. Application source lives in `caliber/`, with the entry point in `caliber/caliberApp.swift` and the initial UI in `caliber/ContentView.swift`. App assets are stored under `caliber/Assets.xcassets`, including app icons and accent colors.

Unit tests live in `caliberTests/` and currently use Swift Testing (`import Testing`). UI tests live in `caliberUITests/` and use XCTest/XCUITest. Project configuration is in `caliber.xcodeproj/`; avoid hand-editing `project.pbxproj` unless an Xcode setting cannot express the change.

## Build, Test, and Development Commands

- `xcodebuild -list -project caliber.xcodeproj`: list available schemes and targets.
- `xcodebuild -project caliber.xcodeproj -scheme caliber build`: build the app from the command line.
- `xcodebuild -project caliber.xcodeproj -scheme caliber test -destination 'platform=iOS Simulator,name=iPhone 16'`: run unit and UI tests on an iOS Simulator. Adjust the simulator name to one installed locally.
- Open `caliber.xcodeproj` in Xcode for interactive development, previews, asset editing, and simulator runs.

## Coding Style & Naming Conventions

Use Swift 5 with Xcode’s default formatting: 4-space indentation, braces on the same line, and concise SwiftUI view declarations. Prefer `struct` views, small computed `body` implementations, and extracted private subviews or helpers once a view becomes hard to scan.

Name types in `UpperCamelCase`, functions and properties in `lowerCamelCase`, and tests after the behavior under test. Keep filenames aligned with primary types, for example `ContentView.swift` for `ContentView`.

## Testing Guidelines

Add unit tests in `caliberTests/` using Swift Testing and `@Test` functions with `#expect(...)` assertions. Add UI coverage in `caliberUITests/` using XCTest when validating app launch, navigation, or visible user flows.

Keep tests deterministic and avoid relying on device state. For UI tests, launch a fresh `XCUIApplication()` in each test or setup path. Run the full test command before opening a pull request.

## Commit & Pull Request Guidelines

The current history only contains `Initial Commit`, so no strict convention is established yet. Use short, imperative commit messages such as `Add onboarding view` or `Fix launch screen tests`.

Pull requests should include a brief summary, test results, and screenshots or screen recordings for visible UI changes. Link related issues when available and call out any simulator, OS, or Xcode version assumptions.

## Security & Configuration Tips

Do not commit secrets, personal signing credentials, or user-specific Xcode data. Keep configuration changes minimal and document any new build settings or required capabilities in the pull request.
