#!/usr/bin/env swift

import Foundation

// Test script to verify shell config parsing works correctly

print("🧪 Testing Shell Config Parsing")
print("==============================")

func parseApiKeyFromShellConfig(_ configPath: String) -> String? {
    let expandedPath = NSString(string: configPath).expandingTildeInPath
    
    print("📁 Checking: \(expandedPath)")
    
    guard let content = try? String(contentsOfFile: expandedPath, encoding: .utf8) else {
        print("   ❌ File not found or not readable")
        return nil
    }
    
    print("   ✅ File found, size: \(content.count) characters")
    
    // Look for export MOONSHOT_API_KEY="..." or export MOONSHOT_API_KEY=...
    let patterns = [
        #"export\s+MOONSHOT_API_KEY\s*=\s*["\']([^"\']+)["\']"#,  // With quotes
        #"export\s+MOONSHOT_API_KEY\s*=\s*([^\s#]+)"#              // Without quotes
    ]
    
    for (index, pattern) in patterns.enumerated() {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            let range = NSRange(content.startIndex..<content.endIndex, in: content)
            
            if let match = regex.firstMatch(in: content, options: [], range: range) {
                let matchRange = Range(match.range(at: 1), in: content)!
                let apiKey = String(content[matchRange])
                
                print("   ✅ Found match with pattern \(index + 1): \(apiKey.prefix(20))...")
                
                // Validate the API key format
                if apiKey.hasPrefix("sk-") && apiKey.count > 10 {
                    print("   ✅ Valid API key format")
                    return apiKey
                } else {
                    print("   ⚠️ Invalid API key format (should start with 'sk-' and be longer than 10 chars)")
                }
            }
        } catch {
            print("   ❌ Regex error: \(error)")
            continue
        }
    }
    
    print("   ❌ No MOONSHOT_API_KEY found")
    return nil
}

// Test the parsing function
let shellConfigPaths = [
    "~/.zshrc",
    "~/.bash_profile", 
    "~/.bashrc",
    "~/.profile"
]

print("🔍 Searching for MOONSHOT_API_KEY in shell config files...")
print("")

var foundApiKey: String? = nil

for configPath in shellConfigPaths {
    if let apiKey = parseApiKeyFromShellConfig(configPath) {
        foundApiKey = apiKey
        break
    }
    print("")
}

print("📊 Results:")
if let apiKey = foundApiKey {
    print("✅ API key found: \(apiKey.prefix(20))...")
    print("🎉 Shell config fallback will work!")
} else {
    print("❌ No API key found in any shell config file")
    print("💡 To test this feature, add to your ~/.zshrc:")
    print("   export MOONSHOT_API_KEY=\"sk-your-api-key-here\"")
}

print("")
print("🔧 Current environment variable:")
if let envKey = ProcessInfo.processInfo.environment["MOONSHOT_API_KEY"] {
    print("✅ MOONSHOT_API_KEY set: \(envKey.prefix(20))...")
} else {
    print("❌ MOONSHOT_API_KEY not set in environment")
}