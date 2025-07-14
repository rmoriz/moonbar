import Foundation

// MARK: - Moonshot Provider

/// Moonshot.ai API provider implementation
struct MoonshotProvider: BalanceProvider {
    let name = "Moonshot.ai"
    let baseURL = "https://api.moonshot.ai/v1"
    
    func fetchBalance(apiKey: String) async throws -> ProviderBalance {
        let url = URL(string: "\(baseURL)/users/me/balance")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.networkError("Invalid response type")
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 401 {
                    throw AppError.authenticationError
                }
                throw AppError.networkError("HTTP \(httpResponse.statusCode)")
            }
            
            // Parse JSON response
            let apiResponse = try JSONDecoder().decode(MoonshotAPIResponse.self, from: data)
            
            guard apiResponse.status else {
                throw AppError.networkError("API returned error: \(apiResponse.scode)")
            }
            
            return MoonshotBalance(
                availableBalance: apiResponse.data.availableBalance,
                voucherBalance: apiResponse.data.voucherBalance,
                cashBalance: apiResponse.data.cashBalance,
                lastUpdated: Date()
            )
            
        } catch let error as AppError {
            throw error
        } catch {
            throw AppError.networkError(error.localizedDescription)
        }
    }
    
    func validateApiKey(_ apiKey: String) async throws -> Bool {
        do {
            _ = try await fetchBalance(apiKey: apiKey)
            return true
        } catch AppError.authenticationError {
            return false
        } catch {
            // Network errors don't necessarily mean invalid key
            throw error
        }
    }
}

// MARK: - Moonshot API Models

/// Moonshot API response structure
struct MoonshotAPIResponse: Codable {
    let code: Int
    let data: MoonshotBalanceData
    let scode: String
    let status: Bool
}

/// Moonshot balance data structure
struct MoonshotBalanceData: Codable {
    let availableBalance: Double
    let voucherBalance: Double
    let cashBalance: Double
    
    enum CodingKeys: String, CodingKey {
        case availableBalance = "available_balance"
        case voucherBalance = "voucher_balance"
        case cashBalance = "cash_balance"
    }
}

// MARK: - Moonshot Balance Implementation

/// Moonshot-specific balance implementation
struct MoonshotBalance: ProviderBalance {
    let availableBalance: Double
    let voucherBalance: Double
    let cashBalance: Double
    let lastUpdated: Date
    
    var primaryBalance: Double {
        return availableBalance
    }
    
    var secondaryBalances: [String: Double] {
        return [
            "voucher": voucherBalance,
            "cash": cashBalance
        ]
    }
    
    var currency: String {
        return "$"
    }
    
    var displayString: String {
        return String(format: "💡 %.2f %@", primaryBalance, currency)
    }
    
    /// Get display string for specific balance type
    func displayString(for type: BalanceDisplayType) -> String {
        switch type {
        case .primary:
            return String(format: "💡 %.2f %@", availableBalance, currency)
        case .secondary("cash"):
            return String(format: "💰 %.2f %@", cashBalance, currency)
        case .secondary("voucher"):
            return String(format: "🎫 %.2f %@", voucherBalance, currency)
        case .secondary(let unknown):
            return String(format: "❓ %.2f %@ (\(unknown))", 0.0, currency)
        }
    }
}

// MARK: - Balance Display Types

enum BalanceDisplayType {
    case primary
    case secondary(String)
    
    /// Get next balance type for cycling
    func next(availableTypes: [String]) -> BalanceDisplayType {
        switch self {
        case .primary:
            return availableTypes.isEmpty ? .primary : .secondary(availableTypes[0])
        case .secondary(let current):
            if let currentIndex = availableTypes.firstIndex(of: current) {
                let nextIndex = (currentIndex + 1) % (availableTypes.count + 1)
                if nextIndex == availableTypes.count {
                    return .primary
                } else {
                    return .secondary(availableTypes[nextIndex])
                }
            } else {
                return .primary
            }
        }
    }
}