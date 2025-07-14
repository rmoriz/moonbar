import Foundation

// MARK: - Balance Fetcher

/// Provider-agnostic balance fetching service
/// Coordinates with different BalanceProvider implementations
class BalanceFetcher {
    
    // MARK: - Properties
    
    private let session: URLSession
    
    // MARK: - Initialization
    
    init() {
        // Configure URL session with appropriate timeouts
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 60.0
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Public Methods
    
    /// Fetch balance for any account using its provider
    /// - Parameter account: Account to fetch balance for
    /// - Returns: Provider-specific balance information
    /// - Throws: Network, authentication, or parsing errors
    func fetchBalance(for account: Account) async throws -> ProviderBalance {
        print("🔄 Fetching balance for \(account.displayName)...")
        
        do {
            let balance = try await account.provider.fetchBalance(apiKey: account.apiKey)
            print("✅ Successfully fetched balance: \(balance.displayString)")
            return balance
            
        } catch let error as AppError {
            print("❌ Balance fetch failed: \(error.localizedDescription)")
            throw error
        } catch {
            print("❌ Unexpected error: \(error.localizedDescription)")
            throw AppError.networkError(error.localizedDescription)
        }
    }
    
    /// Validate API key for any provider
    /// - Parameter account: Account to validate
    /// - Returns: True if API key is valid
    /// - Throws: Network errors
    func validateApiKey(for account: Account) async throws -> Bool {
        print("🔑 Validating API key for \(account.displayName)...")
        
        do {
            let isValid = try await account.provider.validateApiKey(account.apiKey)
            print(isValid ? "✅ API key is valid" : "❌ API key is invalid")
            return isValid
            
        } catch let error as AppError {
            print("❌ API key validation failed: \(error.localizedDescription)")
            throw error
        } catch {
            print("❌ Unexpected validation error: \(error.localizedDescription)")
            throw AppError.networkError(error.localizedDescription)
        }
    }
    
    /// Fetch balances for multiple accounts concurrently
    /// - Parameter accounts: Array of accounts to fetch balances for
    /// - Returns: Dictionary mapping account IDs to their balances
    func fetchBalances(for accounts: [Account]) async -> [UUID: Result<ProviderBalance, Error>] {
        print("🔄 Fetching balances for \(accounts.count) accounts...")
        
        let results = await withTaskGroup(of: (UUID, Result<ProviderBalance, Error>).self) { group in
            
            // Add tasks for each account
            for account in accounts {
                group.addTask {
                    do {
                        let balance = try await self.fetchBalance(for: account)
                        return (account.id, .success(balance))
                    } catch {
                        return (account.id, .failure(error))
                    }
                }
            }
            
            // Collect results
            var results: [UUID: Result<ProviderBalance, Error>] = [:]
            for await (accountId, result) in group {
                results[accountId] = result
            }
            
            return results
        }
        
        let successCount = results.values.compactMap { try? $0.get() }.count
        print("✅ Fetched balances: \(successCount)/\(accounts.count) successful")
        
        return results
    }
}

// MARK: - Network Utilities

extension BalanceFetcher {
    
    /// Check network connectivity
    /// - Returns: True if network appears to be available
    func checkNetworkConnectivity() async -> Bool {
        do {
            let url = URL(string: "https://www.apple.com")!
            let (_, response) = try await session.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
            return false
            
        } catch {
            print("🌐 Network connectivity check failed: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Perform network request with retry logic
    /// - Parameters:
    ///   - request: URL request to perform
    ///   - maxRetries: Maximum number of retry attempts
    ///   - retryDelay: Delay between retries in seconds
    /// - Returns: Response data and URL response
    /// - Throws: Network errors after all retries exhausted
    func performRequestWithRetry(
        _ request: URLRequest,
        maxRetries: Int = 3,
        retryDelay: TimeInterval = 1.0
    ) async throws -> (Data, URLResponse) {
        
        var lastError: Error?
        
        for attempt in 0...maxRetries {
            do {
                let (data, response) = try await session.data(for: request)
                
                // Check for HTTP errors that shouldn't be retried
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 401, 403:
                        // Authentication errors - don't retry
                        throw AppError.authenticationError
                    case 400, 404:
                        // Client errors - don't retry
                        throw AppError.networkError("HTTP \(httpResponse.statusCode)")
                    case 200...299:
                        // Success
                        return (data, response)
                    default:
                        // Server errors - can retry
                        if attempt == maxRetries {
                            throw AppError.networkError("HTTP \(httpResponse.statusCode)")
                        }
                    }
                } else {
                    return (data, response)
                }
                
            } catch let error as AppError {
                // Don't retry AppErrors (they're usually not transient)
                throw error
            } catch {
                lastError = error
                
                if attempt < maxRetries {
                    print("⚠️ Request failed (attempt \(attempt + 1)/\(maxRetries + 1)), retrying in \(retryDelay)s...")
                    try await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
                }
            }
        }
        
        // All retries exhausted
        throw AppError.networkError(lastError?.localizedDescription ?? "Request failed after \(maxRetries) retries")
    }
}