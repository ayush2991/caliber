# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Caliber is a SwiftUI workout tracking app for iOS, backed by SwiftData for persistence. The app entry point is `caliber/caliberApp.swift`, which wires a `ModelContainer` and presents `ContentView` — a four-tab shell (Home / Exercises / History / Profile). UI mockups exist in `mockups/` (see Mockups section below).

## Commands

```bash
# List available schemes
xcodebuild -list -project caliber.xcodeproj

# Build
xcodebuild -project caliber.xcodeproj -scheme caliber build

# Run all tests on simulator
xcodebuild -project caliber.xcodeproj -scheme caliber test \
  -destination 'platform=iOS Simulator,name=iPhone 17'

# Run a single test (unit or UI), e.g. one test class
xcodebuild -project caliber.xcodeproj -scheme caliber test \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:caliberTests/SeedDataTests
```

There is no package manager (CocoaPods/SPM) in use yet.

Don't launch the iOS Simulator or drive the app UI (no `xcrun simctl boot`/`install`/`launch`, no screenshots) by default. Build and test via `xcodebuild` as above, then ask the user whether they'd like UI verification/screenshots for this change — they'll sometimes want it done, sometimes prefer to check manually themselves.

## Architecture

The Xcode project uses synchronized file groups (`PBXFileSystemSynchronizedRootGroup`), so new files dropped into `caliber/`, `caliberTests/`, or `caliberUITests/` are picked up automatically — there's no need to hand-edit `caliber.xcodeproj/project.pbxproj` to add a source file to the build.

**Data layer (SwiftData):**
- `caliber/Models/` — the three `@Model` classes: `Exercise` (name/category/equipment), `WorkoutSession` (a date + its `SetEntry` children, cascade-deleted with the session), `SetEntry` (weight/reps/order, linked to an `Exercise` and its parent `WorkoutSession`). There is no template/routine concept — workouts are logged ad hoc.
- `caliber/caliberApp.swift` creates the single `ModelContainer` for `[Exercise, WorkoutSession, SetEntry]` and injects it app-wide via `.modelContainer(for:)`.
- `caliber/SeedData.swift` holds the built-in exercise library (~18 exercises across Chest/Back/Legs/Shoulders/Arms/Core) and `seedExercisesIfNeeded(in:)`, which idempotently inserts them into an empty store. `ContentView` calls this on `.task` at launch.
- Views read data with `@Query` and write via the `@Environment(\.modelContext)` context directly — there's no repository/service abstraction layer.

**Navigation shell:**
- `caliber/ContentView.swift` is a `TabView` with four tabs, each its own top-level view (`HomeView`, `ExercisesView`, `HistoryView`, `ProfileView`), all wrapped in their own `NavigationStack`.
- `ExercisesView` and `HistoryView` are driven live by `@Query` (exercises grouped by category, sessions sorted by date); `HomeView` and `ProfileView` are currently placeholders.
- Current styling is plain system defaults throughout (no custom theme/colors) since a visual direction hasn't been finalized against the mockups yet — expect this to be restyled once one is picked.

**Tests:**
- `caliberTests/` — unit tests using Swift Testing (`import Testing`, `@Test`, `#expect(...)`). `SeedDataTests` uses an in-memory `ModelContainer` to test seeding, seed idempotency, and cascade-delete behavior without touching the real on-disk store.
- `caliberUITests/` — UI tests using XCTest/XCUITest; each test launches a fresh `XCUIApplication()`.

Keep views as `struct`s with small `body` implementations. Extract private subviews when a view becomes hard to scan.

## Mockups

`mockups/` holds standalone HTML design references (not part of the Xcode build) exploring visual direction before it's built in SwiftUI:

- `mockup-1.html` — a static, black-and-orange iOS-style mockup with a `Home` / `Exercises` / `History` / `Profile` tab bar. Only the Home and Exercises screens are fleshed out; tab switching is a plain JS `display` toggle. Useful as a quick reference for basic screen layout and information density.
- `mockup-2.html` — a self-contained bundled artifact (large file, embeds fonts/assets as base64) that unpacks into a React-based interactive prototype with a warm cream/terracotta light/dark theme. It defines a small component library (`Button`, `Card`, `StatTile`, `CategoryChip`, `CalendarGrid`, `BarChart`, `SetRow`, `RestTimerBar`, `MetricRow`, `ListItem`) shared across five screens (`Today`, `Home`, `History`, `Library`, `Stats`) with a light/dark toggle. `Today` models an in-progress workout (set logging, rest timer), while the others cover the dashboard, workout history, exercise library, and stats views. This is the more complete design system exploration and the better reference for component structure and theming when building the real SwiftUI views.

## Commit style

Short imperative messages: `Add onboarding view`, `Fix launch screen tests`. PRs should include screenshots or recordings for any visible UI change.
