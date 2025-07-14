#!/usr/bin/env swift

import Foundation

print("🔍 Environment Debug Script")
print("==========================")

// Check if API key is available
if let apiKey = ProcessInfo.processInfo.environment["MOONSHOT_API_KEY"] {
    print("✅ MOONSHOT_API_KEY found: \(apiKey.count) characters")
    print("   First 10 chars: \(String(apiKey.prefix(10)))")
} else {
    print("❌ MOONSHOT_API_KEY not found in environment")
}

print("\n📋 All environment variables containing 'MOONSHOT':")
for (key, value) in ProcessInfo.processInfo.environment {
    if key.contains("MOONSHOT") {
        print("   \(key) = \(String(value.prefix(20)))...")
    }
}

print("\n🔧 To fix this issue:")
print("1. Set API key: export MOONSHOT_API_KEY=\"sk-your-key\"")
print("2. Launch Xcode from terminal: open -a Xcode")
print("3. Or configure in Xcode scheme environment variables")