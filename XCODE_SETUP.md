# Xcode Project Setup - Quick Start

You now have all the Swift source files ready! Here's how to quickly set up the Xcode project:

## 🚀 Quick Setup Steps

### 1. Create Xcode Project
Follow the detailed guide in `create-xcode-project.md`, or quick version:

1. **File > New > Project** in Xcode
2. **macOS > App**
3. **Product Name**: `Moonbar`
4. **Interface**: **AppKit** (not SwiftUI)
5. **Language**: Swift
6. **Include Tests**: Yes

### 2. Add Source Files to Xcode

After creating the project, add our source files:

1. **Delete** the default `AppDelegate.swift` and `main.swift` from Xcode
2. **Drag and drop** these folders from Finder into Xcode:
   - `Sources/App/` → into Moonbar group
   - `Sources/Models/` → create Models group
   - `Sources/Services/` → create Services group  
   - `Sources/Utilities/` → create Utilities group

### 3. Configure Info.plist

Add these keys to `Moonbar/Info.plist`:

```xml
<key>LSUIElement</key>
<true/>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>api.moonshot.ai</key>
        <dict>
            <key>NSExceptionRequiresForwardSecrecy</key>
            <false/>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.2</string>
        </dict>
    </dict>
</dict>
```

### 4. Set Environment Variable

```bash
export MOONSHOT_API_KEY="sk-your-actual-api-key"
```

### 5. Launch and Test

```bash
# Launch Xcode with environment
open -a Xcode

# In Xcode:
# Build: ⌘B
# Run: ⌘R
```

## ✅ What You Should See

When you run the app:
- ✅ **No dock icon** appears
- ✅ **Menu bar item** shows "💡 Loading..."
- ✅ **Balance fetches** and displays (e.g., "💡 12.34 $")
- ✅ **Click cycling** works (available → cash → voucher)
- ✅ **Console logs** show detailed operation info

## 🔧 Project Structure in Xcode

```
Moonbar/
├── App/
│   ├── main.swift              # App entry point
│   ├── AppDelegate.swift       # Menu bar & lifecycle
│   └── Info.plist             # App configuration
├── Models/
│   ├── BalanceProvider.swift   # Provider protocols
│   ├── MoonshotProvider.swift  # Moonshot implementation
│   └── Account.swift          # Account management
├── Services/
│   ├── BalanceManager.swift    # Business logic
│   └── BalanceFetcher.swift   # Network operations
├── Utilities/
│   └── Logger.swift           # Structured logging
└── MoonbarTests/              # Test files
```

## 🎯 Key Features Implemented

### **Menu Bar Integration**
- Runs as background app (no dock icon)
- Shows balance in menu bar
- Click to cycle balance types

### **Smart Refresh**
- Auto-updates every 5 minutes
- Pauses when screen locked
- Resumes when screen unlocked

### **Multi-Provider Ready**
- Protocol-based architecture
- Easy to add OpenAI, Anthropic, etc.
- Account management system

### **Robust Error Handling**
- Network timeouts and retries
- Authentication error detection
- Graceful degradation

### **Modern Swift**
- Async/await for network calls
- Structured concurrency
- Thread-safe operations

## 🐛 Troubleshooting

### App doesn't appear in menu bar:
- Check `LSUIElement = true` in Info.plist
- Verify `NSStatusBar` setup in AppDelegate

### "Missing API key" error:
- Ensure `MOONSHOT_API_KEY` is set
- Launch Xcode from terminal: `open -a Xcode`

### Network errors:
- Check API key validity
- Verify network connectivity
- Check console logs for details

### Build errors:
- Ensure deployment target is macOS 12.0+
- Check Swift language version is Swift 5+

## 🚀 Next Steps

Once the basic app is running:

1. **Test all features** (balance display, cycling, error handling)
2. **Add unit tests** for core components
3. **Implement Milestone 3** (advanced features)
4. **Add app icon** and polish UI
5. **Prepare for distribution**

## 📝 Development Notes

- **Logging**: Check Console.app for detailed logs
- **Debugging**: Use Xcode debugger with breakpoints
- **Testing**: Run tests with ⌘U
- **Performance**: Monitor in Instruments

The foundation is complete and ready for development! 🌙✨