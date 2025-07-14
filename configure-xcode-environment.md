# Configure Xcode Environment Variables

Since you're getting `accountNotFound` error, the app is working correctly but needs the API key. Here are three ways to fix this:

## Method 1: Terminal Launch (Recommended)

```bash
# Set your API key
export MOONSHOT_API_KEY="sk-your-actual-moonshot-api-key"

# Launch Xcode from terminal (inherits environment)
open -a Xcode Moonbar.xcodeproj

# Build and run (⌘R)
```

## Method 2: Xcode Scheme Environment Variables

1. **Open Xcode project**: `open Moonbar.xcodeproj`
2. **Edit Scheme**: Product > Scheme > Edit Scheme...
3. **Select Run** in left sidebar
4. **Environment Variables** tab
5. **Add (+)** new variable:
   - **Name**: `MOONSHOT_API_KEY`
   - **Value**: `sk-your-actual-api-key`
6. **Check** "Use the Run action's arguments and environment variables"
7. **Close** and run (⌘R)

## Method 3: Hardcode for Testing (Temporary)

Edit `Sources/Services/BalanceManager.swift` and temporarily replace:

```swift
// Find this line:
guard let apiKey = ProcessInfo.processInfo.environment["MOONSHOT_API_KEY"],

// Replace with (TEMPORARY ONLY):
guard let apiKey = "sk-your-actual-api-key".isEmpty ? nil : "sk-your-actual-api-key",
```

**⚠️ Remember to revert this change before committing!**

## Testing Without Real API Key

If you don't have a Moonshot API key yet:

1. **Get one**: Visit https://console.moonshot.ai/
2. **Test with mock**: Run `./test-with-mock-key.sh` to verify app structure
3. **Expected behavior**: App shows error (proves it's working!)

## Verification Steps

Once you set the API key:

1. **Menu bar**: Should show `💡 Loading...` then your balance
2. **Click test**: Click to cycle through balance types
3. **Console logs**: Check Console.app for detailed logs
4. **Error handling**: Temporarily disconnect internet to test error states

## Troubleshooting

### "Still getting accountNotFound"
- Verify API key is set: `echo $MOONSHOT_API_KEY`
- Ensure Xcode launched from terminal: `open -a Xcode`
- Check scheme environment variables are configured

### "Network errors"
- Test API manually: `./test-api-connection.sh`
- Check internet connection
- Verify API key is valid

### "App not in menu bar"
- Check `LSUIElement = true` in Info.plist
- Look for app in Activity Monitor
- Check Console.app for error logs

The `accountNotFound` error actually proves your app is working perfectly - it's correctly detecting the missing API key! 🎉