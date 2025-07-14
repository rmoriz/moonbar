# Fix Environment Variable in Xcode

The environment variable isn't being passed to the app. Here's how to fix it:

## Method 1: Configure in Xcode Scheme (Recommended)

1. **Open Xcode**: `open Moonbar.xcodeproj`

2. **Edit Scheme**:
   - Click on "Moonbar" next to the play button in toolbar
   - Select "Edit Scheme..." 
   - OR: Product menu > Scheme > Edit Scheme...

3. **Configure Environment**:
   - Select "Run" in the left sidebar
   - Click "Environment Variables" tab
   - Click the "+" button to add new variable
   - **Name**: `MOONSHOT_API_KEY`
   - **Value**: `sk-your-actual-moonshot-api-key-here`
   - Make sure the checkbox is checked ✅

4. **Save and Test**:
   - Click "Close"
   - Build and Run (⌘R)
   - App should now find the API key!

## Method 2: Temporary Code Fix for Testing

If you want to test immediately without an API key, edit `BalanceManager.swift`:

**Find this code** (around line 45):
```swift
guard let apiKey = ProcessInfo.processInfo.environment["MOONSHOT_API_KEY"],
      !apiKey.isEmpty else {
    delegate?.balanceManager(self, didEncounterError: .missingApiKey)
    return
}
```

**Replace with** (TEMPORARY):
```swift
// TEMPORARY: Use mock key for testing
let apiKey = ProcessInfo.processInfo.environment["MOONSHOT_API_KEY"] ?? "sk-mock-key-for-testing"
if apiKey == "sk-mock-key-for-testing" {
    print("⚠️ Using mock API key - will show network error (expected)")
}
```

This will let the app proceed past the environment check and show network errors instead.

## Method 3: Launch App with Environment

```bash
# Set environment and launch app directly
export MOONSHOT_API_KEY="sk-your-key"
"/path/to/Moonbar.app/Contents/MacOS/Moonbar"
```

## Verification

After setting up the environment variable, you should see:
- **With valid key**: `💡 12.34 $` (your actual balance)
- **With invalid key**: `Moonshot: ❌` (network/auth error)
- **No more**: `accountNotFound` error

The Xcode scheme method is most reliable for development!