import Foundation

// MARK: - Provider Protocol

/// Protocol that all AI provider implementations must conform to
/// This enables easy addition of new providers (OpenAI, Anthropic, etc.)
protocol BalanceProvider {
    /// Human-readable name of the provider
    var name: String { get }
    
    /// Base URL for the provider's API
    var baseURL: String { get }
    
    /// Fetch balance for the given API key
    /// - Parameter apiKey: The API key for authentication
    /// - Returns: Provider-specific balance information
    /// - Throws: Network or authentication errors
    func fetchBalance(apiKey: String) async throws -> ProviderBalance
    
    /// Validate if the given API key is valid
    /// - Parameter apiKey: The API key to validate
    /// - Returns: True if valid, false otherwise
    /// - Throws: Network errors
    func validateApiKey(_ apiKey: String) async throws -> Bool
}

// MARK: - Balance Protocol

/// Protocol for normalized balance information across all providers
/// This allows the UI to display any provider's balance consistently
protocol ProviderBalance {
    /// Primary balance to display (main account balance)
    var primaryBalance: Double { get }
    
    /// Additional balance types (e.g., credits, vouchers, etc.)
    var secondaryBalances: [String: Double] { get }
    
    /// Currency code (USD, EUR, etc.)
    var currency: String { get }
    
    /// When this balance was last updated
    var lastUpdated: Date { get }
    
    /// Formatted string for menu bar display
    var displayString: String { get }
}

// MARK: - Default Implementation

extension ProviderBalance {
    /// Default display string implementation
    var displayString: String {
        return String(format: "💡 %.2f %@", primaryBalance, currency)
    }
}

// MARK: - App Errors

enum AppError: Error, LocalizedError {
    case networkError(String)
    case authenticationError
    case parsingError(String)
    case missingApiKey
    case accountNotFound
    case providerNotSupported(String)
    case multipleAccountsNotSupported // For MVP boundaries
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network error: \(message)"
        case .authenticationError:
            return "Authentication failed - check your API key"
        case .parsingError(let message):
            return "Failed to parse response: \(message)"
        case .missingApiKey:
            return "API key not found in environment"
        case .accountNotFound:
            return "Account not found"
        case .providerNotSupported(let provider):
            return "Provider '\(provider)' is not supported"
        case .multipleAccountsNotSupported:
            return "Multiple accounts not supported in MVP"
        }
    }
}