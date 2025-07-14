# Creating the Moonbar Xcode Project

Follow these steps to create the Xcode project with the correct configuration.

## Step 1: Launch Xcode with Environment

```bash
cd moonbar
open -a Xcode
```

## Step 2: Create New Project

1. **File > New > Project** (⌘⇧N)
2. **Choose Template**:
   - Select **macOS** tab
   - Choose **App**
   - Click **Next**

## Step 3: Configure Project Options

Fill in the project details:

- **Product Name**: `Moonbar`
- **Team**: Select your development team
- **Organization Identifier**: `com.moriz.moonbar`
- **Bundle Identifier**: `com.moriz.moonbar` (auto-filled)
- **Language**: **Swift**
- **Interface**: **AppKit** (NOT SwiftUI)
- **Use Core Data**: **Unchecked**
- **Include Tests**: **Checked**

Click **Next**

## Step 4: Choose Location

- Navigate to your `moonbar` directory
- **IMPORTANT**: Uncheck "Create Git repository" (we already have one)
- Click **Create**

## Step 5: Configure Info.plist

Open `Moonbar/Info.plist` and add these keys:

```xml
<key>LSUIElement</key>
<true/>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>api.moonshot.ai</key>
        <dict>
            <key>NSExceptionRequiresForwardSecrecy</key>
            <false/>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.2</string>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
    </dict>
</dict>
```

## Step 6: Configure Build Settings

1. Select **Moonbar** project in navigator
2. Select **Moonbar** target
3. **General** tab:
   - **Deployment Target**: macOS 12.0
   - **Bundle Identifier**: com.moriz.moonbar

4. **Build Settings** tab:
   - Search for "Swift Language Version"
   - Set to **Swift 5**

## Step 7: Organize Project Structure

Create groups in Xcode to match our architecture:

1. Right-click **Moonbar** folder in navigator
2. **New Group** for each:
   - **Models**
   - **Services** 
   - **Utilities**
   - **Resources**

Your structure should look like:
```
Moonbar/
├── App/
│   ├── AppDelegate.swift
│   ├── main.swift
│   └── Info.plist
├── Models/
├── Services/
├── Utilities/
├── Resources/
│   └── Assets.xcassets
└── MoonbarTests/
```

## Step 8: Test Build

1. **Build**: ⌘B
2. **Run**: ⌘R

You should see:
- App launches (may show empty window briefly)
- No dock icon appears
- App appears in menu bar (if LSUIElement is configured correctly)

## Step 9: Commit Initial Project

```bash
git add .
git commit -m "feat(xcode): create initial Xcode project

- Configure macOS app with AppKit interface
- Set LSUIElement for menu bar only app
- Configure network security for Moonshot.ai API
- Set deployment target to macOS 12.0
- Organize project structure for clean architecture

Implements: Milestone 1 - Project Foundation"
```

## Next Steps

Once the project is created, we'll implement:
1. Basic AppDelegate with menu bar integration
2. Provider protocol system
3. Moonshot API integration
4. Balance display logic

Ready to start coding! 🚀