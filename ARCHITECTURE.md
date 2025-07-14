# Architecture Document: Moonshot Balance Menu Bar App

## Overview

The Moonshot Balance Menu Bar App is a native macOS application built with Swift and AppKit that displays API balance information in the menu bar. The architecture follows a clean, modular design with clear separation of concerns.

## System Architecture

### High-Level Components

```
┌─────────────────────────────────────────────────────────────┐
│                    macOS Menu Bar                           │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  💡 12.34 $ (Available Balance Display)            │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   App Delegate                              │
│  • Status Bar Management                                    │
│  • Timer Coordination                                       │
│  • Screen Lock Detection                                    │
│  • Click Handler (Toggle Balance Types)                     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 Balance Manager                             │
│  • State Management                                         │
│  • Balance Type Switching Logic                             │
│  • Error State Handling                                     │
│  • UI Update Coordination                                   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 Balance Fetcher                             │
│  • HTTP API Client                                          │
│  • JSON Response Parsing                                    │
│  • Error Handling & Retry Logic                             │
│  • Network Connectivity Checks                              │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              Moonshot.ai REST API                           │
│  GET /v1/users/me/balance                                   │
│  Authorization: Bearer <API_KEY>                            │
└─────────────────────────────────────────────────────────────┘
```

## Core Components

### 1. AppDelegate
**Responsibility**: Application lifecycle and menu bar integration
- Manages `NSStatusBar` item creation and configuration
- Sets up and manages refresh timer (5-minute intervals)
- Handles screen lock/unlock detection
- Coordinates click events for balance type switching
- Ensures app runs without dock icon

### 2. BalanceManager
**Responsibility**: Business logic and state management
- Maintains current balance state for active account (any provider)
- Handles balance type switching on user click (primary/secondary balances)
- Manages error states and fallback displays
- Coordinates between fetcher and UI updates
- Abstracts both account and provider management
- Single Moonshot account in MVP, extensible for multiple providers/accounts

### 3. BalanceFetcher
**Responsibility**: Provider-agnostic API communication
- Coordinates with multiple BalanceProvider implementations
- Handles authentication via provider-specific methods
- Normalizes responses across different providers
- Implements retry logic and error handling
- Manages network connectivity checks
- Designed to work with any provider (Moonshot, OpenAI, Anthropic, etc.)

### 4. Models & Protocols
**Responsibility**: Data structures, type safety, and provider abstraction

```swift
// Provider Protocol (extensible for multiple AI providers)
protocol BalanceProvider {
    var name: String { get }
    var baseURL: String { get }
    func fetchBalance(apiKey: String) async throws -> ProviderBalance
    func validateApiKey(_ apiKey: String) async throws -> Bool
}

// Generic Balance Protocol (normalized across providers)
protocol ProviderBalance {
    var primaryBalance: Double { get }
    var secondaryBalances: [String: Double] { get }
    var currency: String { get }
    var lastUpdated: Date { get }
}

// Moonshot-specific implementations
struct MoonshotProvider: BalanceProvider {
    let name = "Moonshot.ai"
    let baseURL = "https://api.moonshot.ai/v1"
    
    func fetchBalance(apiKey: String) async throws -> ProviderBalance {
        // Moonshot-specific API call
        return MoonshotBalance(/* ... */)
    }
}

struct MoonshotBalance: ProviderBalance {
    let availableBalance: Double
    let voucherBalance: Double
    let cashBalance: Double
    let lastUpdated: Date
    
    var primaryBalance: Double { availableBalance }
    var secondaryBalances: [String: Double] {
        ["voucher": voucherBalance, "cash": cashBalance]
    }
    var currency: String { "USD" }
}

// Account Management Models (multi-provider, multi-account ready)
struct Account {
    let id: UUID
    let name: String
    let provider: BalanceProvider
    let apiKey: String
    let isActive: Bool
    let lastUpdated: Date?
    let balance: ProviderBalance?
    
    // MVP helper for single Moonshot account
    static func createMoonshotAccount(apiKey: String) -> Account {
        Account(
            id: UUID(),
            name: "Moonshot Account",
            provider: MoonshotProvider(),
            apiKey: apiKey,
            isActive: true,
            lastUpdated: nil,
            balance: nil
        )
    }
}

struct AccountManager {
    private var accounts: [Account] = []
    
    var activeAccount: Account? { 
        accounts.first { $0.isActive } 
    }
    
    var accountsByProvider: [String: [Account]] {
        Dictionary(grouping: accounts) { $0.provider.name }
    }
    
    // MVP: Single account methods
    func setDefaultMoonshotAccount(apiKey: String) {
        let account = Account.createMoonshotAccount(apiKey: apiKey)
        accounts = [account]
    }
    
    // Future: Multi-provider, multi-account methods
    func addAccount(_ account: Account) { /* ... */ }
    func switchToAccount(id: UUID) { /* ... */ }
    func removeAccount(id: UUID) { /* ... */ }
    func getAccounts(for provider: BalanceProvider) -> [Account] { /* ... */ }
}

enum BalanceDisplayType {
    case primary
    case secondary(String) // e.g., secondary("cash"), secondary("voucher")
}

enum AppError {
    case networkError
    case authenticationError
    case parsingError
    case missingApiKey
    case accountNotFound
    case providerNotSupported
    case multipleAccountsNotSupported // For MVP boundaries
}
```

## Technical Decisions

### Framework Choices
- **AppKit**: Required for `NSStatusBar` integration
- **Foundation**: For networking (`URLSession`) and JSON parsing
- **Swift**: Native performance and type safety
- **No SwiftUI**: Keeping MVP simple, AppKit sufficient for menu bar

### State Management
- Single source of truth in `BalanceManager`
- Reactive updates using delegate pattern or closures
- Thread-safe operations for background API calls

### Networking
- `URLSession` for HTTP requests
- Async/await for modern Swift concurrency
- Exponential backoff for retry logic
- Timeout handling (30-second request timeout)

### Error Handling
- Graceful degradation with error state display
- Console logging for debugging
- No user-facing error dialogs (menu bar app should be unobtrusive)

### Security
- API key from environment variable (`MOONSHOT_API_KEY`) for MVP single account
- Account model designed for secure storage (Keychain-ready)
- No local storage of sensitive data in MVP
- Future: macOS Keychain integration per account

## Data Flow

1. **App Launch**:
   - AppDelegate initializes status bar item
   - BalanceManager checks for API key
   - Initial balance fetch triggered

2. **Periodic Updates**:
   - Timer triggers every 5 minutes
   - Screen lock detection prevents unnecessary API calls
   - BalanceFetcher makes API request
   - Response parsed and state updated
   - Menu bar display refreshed

3. **User Interaction**:
   - Click on menu bar item
   - BalanceManager cycles through balance types
   - Display updates immediately

4. **Error Scenarios**:
   - Network failure: Display "❌" with last known balance
   - API error: Display error state
   - Missing API key: Display configuration hint

## Performance Considerations

- **Memory**: Minimal footprint, no UI frameworks beyond AppKit
- **CPU**: Efficient timer management, background thread for API calls
- **Network**: Respectful API usage (5-minute intervals), proper timeout handling
- **Battery**: Screen lock detection prevents unnecessary background activity

## Security Considerations

- API key never logged or stored in plain text
- HTTPS-only communication with Moonshot.ai
- No local data persistence in MVP
- Environment variable isolation

### Scalability & Extensibility

### Multi-Provider, Multi-Account Architecture (Future-Ready):
```swift
// Current MVP Implementation
class BalanceManager {
    private let accountManager = AccountManager()
    private let fetcher = BalanceFetcher()
    
    // MVP: Single Moonshot account
    func updateBalance() {
        guard let account = accountManager.activeAccount else { return }
        fetcher.fetchBalance(for: account) { /* ... */ }
    }
    
    // Future: Multi-provider, multi-account methods (already structured)
    func updateBalance(for accountId: UUID) { /* ... */ }
    func updateAllAccounts() { /* ... */ }
    func updateAccountsForProvider(_ providerName: String) { /* ... */ }
    func switchProvider(to providerName: String) { /* ... */ }
}

// Provider Registration System (Future)
class ProviderRegistry {
    private var providers: [String: BalanceProvider] = [:]
    
    func register(_ provider: BalanceProvider) {
        providers[provider.name] = provider
    }
    
    func getProvider(_ name: String) -> BalanceProvider? {
        return providers[name]
    }
}
```

### Future Enhancements Ready:
- **Multiple Providers**: OpenAI, Anthropic, Cohere, etc. via BalanceProvider protocol
- **Multiple Accounts per Provider**: AccountManager groups by provider
- **Provider Switching**: UI can switch between providers and their accounts
- **Unified Balance Display**: Normalized ProviderBalance protocol
- **Provider-Specific Features**: Each provider can implement unique capabilities
- **Account Management UI**: Provider-aware account selection
- **Keychain Integration**: Per-provider, per-account secure storage

### Plugin Architecture:
- **BalanceProvider Protocol**: Easy to add new AI providers (OpenAI, Anthropic, etc.)
- **Provider Registry**: Dynamic provider registration and discovery
- **Normalized Balance Interface**: Consistent API across all providers
- **Provider-Specific Extensions**: Custom features per provider
- **Pluggable Display Formatters**: Provider-aware formatting
- **Future Plugin System**: Load providers from external bundles

## Testing Strategy

- **Unit Tests**: BalanceFetcher, BalanceManager logic
- **Integration Tests**: API communication with mock server
- **UI Tests**: Menu bar interaction and display updates
- **Manual Testing**: Screen lock/unlock scenarios, network interruption

## Deployment Architecture

```
Developer Machine
├── Xcode Project
├── Swift Source Files
├── Info.plist (LSUIElement = true)
└── Build Configuration

Runtime Environment
├── macOS Menu Bar
├── Background Process
├── Environment Variables
└── Network Access to api.moonshot.ai
```

## Dependencies

### External Dependencies
- **None**: Pure Swift/AppKit implementation
- **System**: macOS 12.0+ (for modern Swift concurrency)

### Internal Dependencies
```
main.swift
└── AppDelegate
    ├── BalanceManager
    │   ├── BalanceFetcher
    │   └── Models
    └── NSStatusBar (AppKit)
```

This architecture ensures a clean, maintainable, and extensible codebase while meeting all MVP requirements and preparing for future enhancements.