#!/usr/bin/env swift

// Quick fix to test the app without environment setup
// This modifies BalanceManager.swift to use a mock key

import Foundation

let balanceManagerPath = "Sources/Services/BalanceManager.swift"

print("🔧 Quick Fix: Adding mock API key for testing")
print("============================================")

// Read the current file
guard let content = try? String(contentsOfFile: balanceManagerPath) else {
    print("❌ Could not read BalanceManager.swift")
    exit(1)
}

// Find the problematic line and replace it
let oldCode = """
        guard let apiKey = ProcessInfo.processInfo.environment["MOONSHOT_API_KEY"],
              !apiKey.isEmpty else {
            delegate?.balanceManager(self, didEncounterError: .missingApiKey)
            return
        }
"""

let newCode = """
        // TEMPORARY: Mock API key for testing (will show network error)
        let apiKey = ProcessInfo.processInfo.environment["MOONSHOT_API_KEY"] ?? "sk-mock-key-for-testing"
        if apiKey == "sk-mock-key-for-testing" {
            print("⚠️ Using mock API key - will show network error (expected)")
        }
"""

if content.contains("guard let apiKey = ProcessInfo.processInfo.environment[\"MOONSHOT_API_KEY\"]") {
    let updatedContent = content.replacingOccurrences(of: oldCode, with: newCode)
    
    do {
        try updatedContent.write(toFile: balanceManagerPath, atomically: true, encoding: .utf8)
        print("✅ Successfully updated BalanceManager.swift")
        print("📝 Changes made:")
        print("   - Removed environment variable requirement")
        print("   - Added mock API key fallback")
        print("   - App will now proceed past account setup")
        print("")
        print("🚀 Now rebuild and run the app:")
        print("   1. Build: ⌘B")
        print("   2. Run: ⌘R")
        print("   3. Expected: App shows 'Moonshot: ❌' (network error with mock key)")
        print("")
        print("⚠️ REMEMBER: This is temporary for testing!")
        print("   To revert: git checkout Sources/Services/BalanceManager.swift")
    } catch {
        print("❌ Failed to write file: \(error)")
    }
} else {
    print("⚠️ Code pattern not found - file may already be modified")
    print("   Current environment check in file:")
    
    // Show relevant lines
    let lines = content.components(separatedBy: .newlines)
    for (index, line) in lines.enumerated() {
        if line.contains("MOONSHOT_API_KEY") {
            print("   Line \(index + 1): \(line.trimmingCharacters(in: .whitespaces))")
        }
    }
}

print("")
print("💡 Alternative: Configure environment in Xcode scheme")
print("   See fix-environment-xcode.md for detailed instructions")