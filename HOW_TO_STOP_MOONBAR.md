# How to Stop Moonbar App

Since Moonbar is a menu bar-only app (no dock icon), here are the proper ways to stop it:

## 🎯 Recommended Methods

### **Method 1: Right-Click Menu Bar Item (Future)**
*Note: This will be implemented in a future version*
- Right-click the Moonbar icon in menu bar
- Select "Quit Moonbar"

### **Method 2: Activity Monitor (GUI)**
1. Open **Activity Monitor** (Applications > Utilities)
2. Search for "Moonbar"
3. Select the Moonbar process
4. Click **Force Quit** button (⚠️ icon)

### **Method 3: Terminal Command**
```bash
# Find and kill Moonbar process
pkill -f Moonbar

# Or more specific:
killall Moonbar
```

### **Method 4: Process ID Method**
```bash
# Find the process ID
ps aux | grep -i moonbar | grep -v grep

# Kill by PID (replace XXXX with actual PID)
kill XXXX
```

## 🔧 Development Methods

### **Method 5: Xcode Stop**
If running from Xcode:
- Press **⌘.** (Command + Period) to stop
- Or click the **Stop** button in Xcode

### **Method 6: Force Quit Applications**
1. Press **⌘⌥⎋** (Command + Option + Escape)
2. Select "Moonbar" from the list
3. Click **Force Quit**

## 🚀 Future Improvements

We should add a proper quit menu to the app. Here's what we'll implement:

### **Planned: Right-Click Context Menu**
```swift
// Future implementation in AppDelegate
private func setupContextMenu() {
    let menu = NSMenu()
    
    // Balance info
    menu.addItem(NSMenuItem(title: "Balance: $12.34", action: nil, keyEquivalent: ""))
    menu.addItem(NSMenuItem.separator())
    
    // Refresh action
    menu.addItem(NSMenuItem(title: "Refresh Now", action: #selector(refreshBalance), keyEquivalent: "r"))
    
    // Preferences (future)
    menu.addItem(NSMenuItem(title: "Preferences...", action: #selector(showPreferences), keyEquivalent: ","))
    menu.addItem(NSMenuItem.separator())
    
    // Quit option
    menu.addItem(NSMenuItem(title: "Quit Moonbar", action: #selector(quitApp), keyEquivalent: "q"))
    
    statusBarItem?.menu = menu
}

@objc private func quitApp() {
    NSApplication.shared.terminate(nil)
}
```

## 🎯 Current Best Practice

**For now, use Activity Monitor or Terminal:**

```bash
# Quick terminal command to stop Moonbar
pkill -f Moonbar
```

## ⚠️ Important Notes

- **No Dock Icon**: Moonbar runs as `LSUIElement = true`, so it won't appear in dock
- **Background Process**: It runs quietly in the background
- **Menu Bar Only**: Only visible in the menu bar
- **Graceful Shutdown**: The app handles cleanup when terminated properly

## 🔍 Verify App is Stopped

```bash
# Check if Moonbar is still running
ps aux | grep -i moonbar | grep -v grep

# If no output, the app is stopped
```

This is a common pattern for menu bar apps. We'll add a proper quit menu in the next update!