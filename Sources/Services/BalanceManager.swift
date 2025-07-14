import Foundation

// MARK: - Balance Manager Delegate

protocol BalanceManagerDelegate: AnyObject {
    func balanceManager(_ manager: BalanceManager, didUpdateBalance balance: String)
    func balanceManager(_ manager: BalanceManager, didEncounterError error: AppError)
}

// MARK: - Balance Manager

/// Manages balance fetching, display, and user interactions
/// Coordinates between AccountManager, BalanceFetcher, and UI
class BalanceManager {
    
    // MARK: - Properties
    
    weak var delegate: BalanceManagerDelegate?
    
    private let accountManager: AccountManager
    private let balanceFetcher: BalanceFetcher
    private var currentDisplayType: BalanceDisplayType = .primary
    
    // MARK: - Initialization
    
    init() {
        self.accountManager = AccountManager()
        self.balanceFetcher = BalanceFetcher()
        
        setupDefaultAccount()
    }
    
    // MARK: - Public Methods
    
    /// Update balance for active account
    func updateBalance() {
        guard let activeAccount = accountManager.activeAccount else {
            delegate?.balanceManager(self, didEncounterError: .accountNotFound)
            return
        }
        
        Task {
            do {
                let balance = try await balanceFetcher.fetchBalance(for: activeAccount)
                
                // Update account with new balance
                accountManager.updateActiveAccountBalance(balance)
                
                // Update UI
                await MainActor.run {
                    updateDisplayString()
                }
                
            } catch let error as AppError {
                await MainActor.run {
                    delegate?.balanceManager(self, didEncounterError: error)
                }
            } catch {
                await MainActor.run {
                    delegate?.balanceManager(self, didEncounterError: .networkError(error.localizedDescription))
                }
            }
        }
    }
    
    /// Switch between different balance display types (primary, secondary)
    func switchBalanceType() {
        guard let activeAccount = accountManager.activeAccount,
              let balance = activeAccount.balance else {
            return
        }
        
        // Get available secondary balance types
        let availableTypes = Array(balance.secondaryBalances.keys)
        
        // Switch to next display type
        currentDisplayType = currentDisplayType.next(availableTypes: availableTypes)
        
        // Update display
        updateDisplayString()
        
        print("🔄 Switched to display type: \(currentDisplayType)")
    }
    
    // MARK: - Private Methods
    
    private func setupDefaultAccount() {
        // Try to get API key from environment
        guard let apiKey = ProcessInfo.processInfo.environment["MOONSHOT_API_KEY"],
              !apiKey.isEmpty else {
            delegate?.balanceManager(self, didEncounterError: .missingApiKey)
            return
        }
        
        accountManager.setDefaultMoonshotAccount(apiKey: apiKey)
        print("✅ Balance manager configured with Moonshot account")
    }
    
    private func updateDisplayString() {
        guard let activeAccount = accountManager.activeAccount,
              let balance = activeAccount.balance else {
            delegate?.balanceManager(self, didEncounterError: .accountNotFound)
            return
        }
        
        let displayString: String
        
        // Handle different display types
        if let moonshotBalance = balance as? MoonshotBalance {
            displayString = moonshotBalance.displayString(for: currentDisplayType)
        } else {
            // Fallback for other provider types
            switch currentDisplayType {
            case .primary:
                displayString = balance.displayString
            case .secondary(let type):
                if let secondaryValue = balance.secondaryBalances[type] {
                    displayString = String(format: "💰 %.2f %@", secondaryValue, balance.currency)
                } else {
                    displayString = balance.displayString
                }
            }
        }
        
        delegate?.balanceManager(self, didUpdateBalance: displayString)
    }
}

// MARK: - Future Extensions

extension BalanceManager {
    
    /// Switch to next account (for future multi-account support)
    func switchToNextAccount() {
        accountManager.switchToNextAccount()
        currentDisplayType = .primary // Reset display type when switching accounts
        updateDisplayString()
    }
    
    /// Add new account (for future multi-account support)
    func addAccount(_ account: Account) {
        accountManager.addAccount(account)
    }
    
    /// Get current account info for UI
    var currentAccountInfo: String? {
        return accountManager.activeAccount?.displayName
    }
    
    /// Check if configuration is valid
    var isConfigured: Bool {
        return accountManager.hasValidConfiguration
    }
}