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
        // Try to get API key from environment first
        var apiKey = ProcessInfo.processInfo.environment["MOONSHOT_API_KEY"]
        
        // If not found in environment, try to read from shell config files
        if apiKey?.isEmpty != false {
            print("API key not found in environment, checking shell config files...")
            apiKey = readApiKeyFromShellConfig()
        }
        
        guard let validApiKey = apiKey, !validApiKey.isEmpty else {
            print("ERROR: MOONSHOT_API_KEY not found in environment or shell config")
            delegate?.balanceManager(self, didEncounterError: .missingApiKey)
            return
        }
        
        accountManager.setDefaultMoonshotAccount(apiKey: validApiKey)
        print("SUCCESS: Balance manager configured with Moonshot account")
    }
    
    private func readApiKeyFromShellConfig() -> String? {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        let shellConfigFiles = [
            ".zshrc",
            ".bash_profile", 
            ".bashrc",
            ".profile"
        ]
        
        for configFile in shellConfigFiles {
            let configPath = homeDir.appendingPathComponent(configFile)
            
            guard let content = try? String(contentsOf: configPath, encoding: .utf8) else {
                continue
            }
            
            // Look for export MOONSHOT_API_KEY="..." patterns
            let patterns = [
                #"export\s+MOONSHOT_API_KEY\s*=\s*["\']([^"\']+)["\']"#,  // With quotes
                #"export\s+MOONSHOT_API_KEY\s*=\s*([^\s#]+)"#              // Without quotes
            ]
            
            for pattern in patterns {
                if let regex = try? NSRegularExpression(pattern: pattern, options: []),
                   let match = regex.firstMatch(in: content, options: [], range: NSRange(content.startIndex..., in: content)) {
                    
                    let captureRange = match.range(at: 1)
                    if let range = Range(captureRange, in: content) {
                        let apiKey = String(content[range])
                        print("SUCCESS: Found MOONSHOT_API_KEY in \(configFile)")
                        return apiKey
                    }
                }
            }
        }
        
        print("WARNING: MOONSHOT_API_KEY not found in any shell config file")
        return nil
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