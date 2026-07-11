# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Caliber is a SwiftUI workout tracking app for iOS. It is in early development — the app entry point is `caliber/caliberApp.swift` and the only view so far is `caliber/ContentView.swift`. UI mockups exist in `mockups/` (see Mockups section below).

## Commands

```bash
# List available schemes
xcodebuild -list -project caliber.xcodeproj

# Build
xcodebuild -project caliber.xcodeproj -scheme caliber build

# Run all tests on simulator
xcodebuild -project caliber.xcodeproj -scheme caliber test \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

There is no package manager (CocoaPods/SPM) in use yet.

## Architecture

- `caliber/` — all app source. Entry point: `caliberApp.swift` → `ContentView.swift`.
- `caliberTests/` — unit tests using Swift Testing (`import Testing`, `@Test`, `#expect(...)`).
- `caliberUITests/` — UI tests using XCTest/XCUITest; each test launches a fresh `XCUIApplication()`.
- `caliber/Assets.xcassets` — images, app icon, and `AccentColor`.

Keep views as `struct`s with small `body` implementations. Extract private subviews when a view becomes hard to scan. Avoid hand-editing `caliber.xcodeproj/project.pbxproj`.

## Mockups

`mockups/` holds standalone HTML design references (not part of the Xcode build) exploring visual direction before it's built in SwiftUI:

- `mockup-1.html` — a static, black-and-orange iOS-style mockup with a `Home` / `Exercises` / `History` / `Profile` tab bar. Only the Home and Exercises screens are fleshed out; tab switching is a plain JS `display` toggle. Useful as a quick reference for basic screen layout and information density.
- `mockup-2.html` — a self-contained bundled artifact (large file, embeds fonts/assets as base64) that unpacks into a React-based interactive prototype with a warm cream/terracotta light/dark theme. It defines a small component library (`Button`, `Card`, `StatTile`, `CategoryChip`, `CalendarGrid`, `BarChart`, `SetRow`, `RestTimerBar`, `MetricRow`, `ListItem`) shared across five screens (`Today`, `Home`, `History`, `Library`, `Stats`) with a light/dark toggle. `Today` models an in-progress workout (set logging, rest timer), while the others cover the dashboard, workout history, exercise library, and stats views. This is the more complete design system exploration and the better reference for component structure and theming when building the real SwiftUI views.

## Commit style

Short imperative messages: `Add onboarding view`, `Fix launch screen tests`. PRs should include screenshots or recordings for any visible UI change.
