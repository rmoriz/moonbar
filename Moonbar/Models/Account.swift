import Foundation

// MARK: - Account Model

/// Represents a user account for a specific provider
/// Designed to support multiple providers and multiple accounts per provider
struct Account {
    let id: UUID
    let name: String
    let provider: BalanceProvider
    let apiKey: String
    let isActive: Bool
    let lastUpdated: Date?
    let balance: ProviderBalance?
    
    init(id: UUID = UUID(), 
         name: String, 
         provider: BalanceProvider, 
         apiKey: String, 
         isActive: Bool = false,
         lastUpdated: Date? = nil,
         balance: ProviderBalance? = nil) {
        self.id = id
        self.name = name
        self.provider = provider
        self.apiKey = apiKey
        self.isActive = isActive
        self.lastUpdated = lastUpdated
        self.balance = balance
    }
    
    /// Create a new account with updated balance
    func withUpdatedBalance(_ balance: ProviderBalance) -> Account {
        return Account(
            id: self.id,
            name: self.name,
            provider: self.provider,
            apiKey: self.apiKey,
            isActive: self.isActive,
            lastUpdated: Date(),
            balance: balance
        )
    }
    
    /// Create a new account with updated active status
    func withActiveStatus(_ isActive: Bool) -> Account {
        return Account(
            id: self.id,
            name: self.name,
            provider: self.provider,
            apiKey: self.apiKey,
            isActive: isActive,
            lastUpdated: self.lastUpdated,
            balance: self.balance
        )
    }
}

// MARK: - Account Extensions

extension Account {
    /// MVP helper for creating single Moonshot account
    static func createMoonshotAccount(apiKey: String, name: String = "Moonshot Account") -> Account {
        return Account(
            name: name,
            provider: MoonshotProvider(),
            apiKey: apiKey,
            isActive: true
        )
    }
    
    /// Check if account needs refresh (older than 5 minutes)
    var needsRefresh: Bool {
        guard let lastUpdated = lastUpdated else { return true }
        return Date().timeIntervalSince(lastUpdated) > 300 // 5 minutes
    }
    
    /// Display name for UI
    var displayName: String {
        return "\(provider.name): \(name)"
    }
}

// MARK: - Account Manager

/// Manages multiple accounts across different providers
/// MVP: Single account support with multi-account architecture ready
class AccountManager {
    
    // MARK: - Properties
    
    private var accounts: [Account] = []
    
    /// Currently active account
    var activeAccount: Account? {
        return accounts.first { $0.isActive }
    }
    
    /// All accounts grouped by provider
    var accountsByProvider: [String: [Account]] {
        return Dictionary(grouping: accounts) { $0.provider.name }
    }
    
    /// All available providers
    var availableProviders: [String] {
        return Array(Set(accounts.map { $0.provider.name }))
    }
    
    // MARK: - MVP Methods (Single Account)
    
    /// Set up single Moonshot account for MVP
    /// - Parameter apiKey: Moonshot API key from environment
    func setDefaultMoonshotAccount(apiKey: String) {
        let account = Account.createMoonshotAccount(apiKey: apiKey)
        accounts = [account]
        print("✅ Default Moonshot account configured")
    }
    
    /// Update balance for active account
    /// - Parameter balance: New balance information
    func updateActiveAccountBalance(_ balance: ProviderBalance) {
        guard let activeAccount = activeAccount else { return }
        
        let updatedAccount = activeAccount.withUpdatedBalance(balance)
        updateAccount(updatedAccount)
    }
    
    // MARK: - Future Methods (Multi-Account Support)
    
    /// Add a new account
    /// - Parameter account: Account to add
    func addAccount(_ account: Account) {
        // Deactivate other accounts if this one should be active
        if account.isActive {
            accounts = accounts.map { $0.withActiveStatus(false) }
        }
        
        accounts.append(account)
        print("✅ Added account: \(account.displayName)")
    }
    
    /// Switch to specific account
    /// - Parameter accountId: ID of account to activate
    func switchToAccount(id: UUID) {
        accounts = accounts.map { account in
            account.withActiveStatus(account.id == id)
        }
        
        if let newActive = activeAccount {
            print("✅ Switched to account: \(newActive.displayName)")
        }
    }
    
    /// Remove account
    /// - Parameter accountId: ID of account to remove
    func removeAccount(id: UUID) {
        let removedAccount = accounts.first { $0.id == id }
        accounts.removeAll { $0.id == id }
        
        // If we removed the active account, activate the first remaining one
        if removedAccount?.isActive == true && !accounts.isEmpty {
            accounts[0] = accounts[0].withActiveStatus(true)
        }
        
        if let removed = removedAccount {
            print("✅ Removed account: \(removed.displayName)")
        }
    }
    
    /// Get accounts for specific provider
    /// - Parameter provider: Provider to filter by
    /// - Returns: Array of accounts for that provider
    func getAccounts(for provider: BalanceProvider) -> [Account] {
        return accounts.filter { $0.provider.name == provider.name }
    }
    
    /// Switch to next account (cycling through all accounts)
    func switchToNextAccount() {
        guard accounts.count > 1 else { return }
        
        if let currentActiveIndex = accounts.firstIndex(where: { $0.isActive }) {
            let nextIndex = (currentActiveIndex + 1) % accounts.count
            switchToAccount(id: accounts[nextIndex].id)
        } else if !accounts.isEmpty {
            switchToAccount(id: accounts[0].id)
        }
    }
    
    // MARK: - Private Methods
    
    private func updateAccount(_ updatedAccount: Account) {
        if let index = accounts.firstIndex(where: { $0.id == updatedAccount.id }) {
            accounts[index] = updatedAccount
        }
    }
}

// MARK: - Account Manager Extensions

extension AccountManager {
    /// Check if any accounts need refresh
    var hasAccountsNeedingRefresh: Bool {
        return accounts.contains { $0.needsRefresh }
    }
    
    /// Get all accounts that need refresh
    var accountsNeedingRefresh: [Account] {
        return accounts.filter { $0.needsRefresh }
    }
    
    /// Validate that we have at least one account configured
    var hasValidConfiguration: Bool {
        return !accounts.isEmpty && activeAccount != nil
    }
}