#!/usr/bin/env swift

import Foundation

// Script to add API key logging to BalanceManager.swift

let filePath = "Sources/Services/BalanceManager.swift"

print("🔧 Adding API key logging to BalanceManager.swift")
print("==============================================")

guard let content = try? String(contentsOfFile: filePath, encoding: .utf8) else {
    print("❌ Could not read BalanceManager.swift")
    exit(1)
}

var updatedContent = content

// Add logging to setupDefaultAccount
let setupAccountOld = """
        accountManager.setDefaultMoonshotAccount(apiKey: apiKey)
        print("✅ Balance manager configured with Moonshot account")
"""

let setupAccountNew = """
        // Log API key for debugging (first 20 chars + length)
        let maskedKey = "\\(apiKey.prefix(20))... (\\(apiKey.count) chars)"
        print("🔑 Using API key: \\(maskedKey)")
        
        accountManager.setDefaultMoonshotAccount(apiKey: apiKey)
        print("✅ Balance manager configured with Moonshot account")
"""

updatedContent = updatedContent.replacingOccurrences(of: setupAccountOld, with: setupAccountNew)

// Add logging to getApiKey method
let getApiKeyOld = """
        // First, try environment variable (highest priority)
        if let envApiKey = ProcessInfo.processInfo.environment["MOONSHOT_API_KEY"],
           !envApiKey.isEmpty {
            print("✅ Found API key in environment variable")
            return envApiKey
        }
        
        // Fallback: Parse shell configuration files
        print("🔍 API key not found in environment, checking shell config files...")
"""

let getApiKeyNew = """
        print("🔍 Starting API key detection...")
        
        // First, try environment variable (highest priority)
        if let envApiKey = ProcessInfo.processInfo.environment["MOONSHOT_API_KEY"],
           !envApiKey.isEmpty {
            let maskedKey = "\\(envApiKey.prefix(20))... (\\(envApiKey.count) chars)"
            print("✅ Found API key in environment variable: \\(maskedKey)")
            return envApiKey
        }
        
        // Fallback: Parse shell configuration files
        print("🔍 API key not found in environment, checking shell config files...")
"""

updatedContent = updatedContent.replacingOccurrences(of: getApiKeyOld, with: getApiKeyNew)

// Add detailed file checking
let fileCheckOld = """
        for configPath in shellConfigPaths {
            if let apiKey = parseApiKeyFromShellConfig(configPath) {
                print("✅ Found API key in \\(configPath)")
                return apiKey
            }
        }
"""

let fileCheckNew = """
        for configPath in shellConfigPaths {
            print("📁 Checking \\(configPath)...")
            if let apiKey = parseApiKeyFromShellConfig(configPath) {
                let maskedKey = "\\(apiKey.prefix(20))... (\\(apiKey.count) chars)"
                print("✅ Found API key in \\(configPath): \\(maskedKey)")
                return apiKey
            } else {
                print("   ❌ No API key found in \\(configPath)")
            }
        }
"""

updatedContent = updatedContent.replacingOccurrences(of: fileCheckOld, with: fileCheckNew)

// Write the updated content
do {
    try updatedContent.write(toFile: filePath, atomically: true, encoding: .utf8)
    print("✅ Successfully added API key logging to BalanceManager.swift")
    print("")
    print("📝 Added logging for:")
    print("  - API key detection process start")
    print("  - Environment variable detection with masked key")
    print("  - Shell config file checking progress")
    print("  - Final API key selection with masked key")
    print("  - Detailed file-by-file search results")
    print("")
    print("🚀 Now rebuild and run to see detailed API key logs!")
} catch {
    print("❌ Failed to write file: \\(error)")
    exit(1)
}