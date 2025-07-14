# Product Requirements Document: Moonshot Balance Menu Bar App

## Overview

The Moonshot Balance Menu Bar App is a lightweight, native macOS application that displays a user's current API balance from Moonshot.ai directly in the macOS menu bar. It runs quietly in the background, periodically fetching and updating the displayed balance via Moonshot's REST API.

---

## Goals

- Display real-time or near-real-time API balance from [Moonshot.ai](https://moonshot.ai) in the macOS menu bar.
- Run as a native menu bar-only app (no dock icon, no visible window).
- Automatically refresh the balance at a user-defined interval (default: every 5 minutes).
- Provide clean and readable UI with native macOS integration (dark mode, system font, etc.).
- Handle network/API failures gracefully with fallback or error state in the UI.
- Should support multiple accounts (API keys)

---

## Non-Goals

- No login or UI-based authentication.
- No preferences window in MVP.
- No support for multiple Moonshot accounts.
- No iCloud or multi-device sync.

---

## Users

- Developers or AI enthusiasts who use Moonshot.ai and want quick access to their remaining API credits without opening a dashboard or browser.

---

## Key Features

### ✅ Native macOS Menu Bar Integration

- Uses `NSStatusBar` to create a persistent menu bar item.
- Displays balance like: `💡 12.34 $`.

### ✅ Background API Fetching

- Fetches balance using:
  ```
  GET https://api.moonshot.ai/v1/users/me/balance
  Headers:
    Authorization: Bearer <API_KEY>
  ```
- Parses result, should display available_balance, a mouse click should switch to cash_balance

  ```json
  {
    "code": 0,
    "data": {
      "available_balance": 49.58894,
      "voucher_balance": 46.58893,
      "cash_balance": 3.00001
    },
    "scode": "0x0",
    "status": true
  }
  ```

### ✅ Configurable API Key

- Reads the API key from an environment variable (`MOONSHOT_API_KEY`).
- Optional: Later via macOS Keychain or UI prompt.

### ✅ Auto Refresh

- Fetches and updates balance every 5 minutes using a `Timer`.
- should not fetch if screen is locked/screensaver is active.
- should update values once screen is unlocked again.

### ✅ Error Handling

- Displays `Moonshot: ❌` on error or no connectivity.
- Logs error details to console for debugging.

---

## Architecture

- Written in **Swift** using **AppKit** (for `NSStatusBar`) and optionally **SwiftUI** (for future popover UI).
- No main window or storyboard.
- Core components:
  - `AppDelegate`: Sets up status bar item and fetch timer.
  - `BalanceFetcher`: Encapsulates API logic.
  - `main.swift`: Entry point to start app.

---

## Environment Setup

- User must export the API key in their shell config:
  ```bash
  export MOONSHOT_API_KEY="sk-..."
  ```
- Xcode must be launched from the terminal with this environment:
  ```bash
  open -a Xcode
  ```

---

## Future Enhancements (Post-MVP)

- UI to enter and store API key securely via macOS Keychain.
- Preferences panel (polling interval, currency, API key).
- Optional notifications for low balance threshold.
- Optional popover UI with additional info (e.g. usage history).
- Auto-launch at login.
- Signed and notarized build for distribution.

---

## MVP Success Criteria

- User sees current balance in macOS menu bar within 1 minute of app launch.
- Balance auto-refreshes without user interaction.
- App is unobtrusive, does not appear in Dock or app switcher.
- No crashes or hangs on invalid/missing API key.

---

## License

MIT License (default, unless otherwise specified).

---

## Copyright

(c) 2025, Moriz GmbH
