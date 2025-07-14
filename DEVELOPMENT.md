# Development Guide

This guide helps you set up and develop Moonbar on macOS.

## Prerequisites

### System Requirements
- **macOS**: 12.0+ (Monterey or later)
- **Xcode**: 15.0+ (for Swift 5.9+ support)
- **Swift**: 5.9+ (included with Xcode)

### Development Tools
- **Git**: For version control
- **GitHub CLI** (optional): For easier GitHub integration

## Environment Setup

### 1. Clone the Repository

```bash
git clone https://github.com/rmoriz/moonbar.git
cd moonbar
```

### 2. Set Up Environment Variables

Create your environment configuration:

```bash
cp .env.example .env
```

Edit `.env` and add your API keys:

```bash
# Required for MVP
MOONSHOT_API_KEY=sk-your-actual-moonshot-api-key

# Optional for future development
# OPENAI_API_KEY=sk-your-openai-key
# ANTHROPIC_API_KEY=sk-ant-your-anthropic-key
```

### 3. Configure Shell Environment

Add to your shell profile (`~/.zshrc` or `~/.bash_profile`):

```bash
# Moonbar Development
export MOONSHOT_API_KEY="sk-your-actual-moonshot-api-key"

# Optional: Load from .env file
# if [ -f ~/path/to/moonbar/.env ]; then
#     export $(cat ~/path/to/moonbar/.env | xargs)
# fi
```

Reload your shell:
```bash
source ~/.zshrc  # or ~/.bash_profile
```

### 4. Verify Setup

Run the setup script:
```bash
./setup-dev-env.sh
```

This will check:
- ✅ macOS version compatibility
- ✅ Xcode installation and version
- ✅ Swift version
- ✅ Environment variables
- ✅ Project structure

## Creating the Xcode Project

### 1. Launch Xcode with Environment

**Important**: Launch Xcode from the terminal to inherit environment variables:

```bash
cd moonbar
open -a Xcode
```

### 2. Create New Project

1. **File > New > Project**
2. **macOS > App**
3. **Product Name**: `Moonbar`
4. **Bundle Identifier**: `com.moriz.moonbar`
5. **Language**: Swift
6. **Interface**: AppKit (not SwiftUI)
7. **Use Core Data**: No
8. **Include Tests**: Yes

### 3. Configure Project Settings

#### Info.plist Configuration
Add these keys to `Info.plist`:

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

#### Build Settings
- **Deployment Target**: macOS 12.0
- **Swift Language Version**: Swift 5
- **Code Signing**: Development team

### 4. Project Structure

Organize your Xcode project to match the planned architecture:

```
Moonbar/
├── App/
│   ├── AppDelegate.swift
│   ├── main.swift
│   └── Info.plist
├── Models/
│   ├── BalanceProvider.swift
│   ├── Account.swift
│   └── MoonshotProvider.swift
├── Services/
│   ├── BalanceManager.swift
│   ├── BalanceFetcher.swift
│   └── AccountManager.swift
├── Utilities/
│   ├── Logger.swift
│   └── Extensions.swift
└── Resources/
    └── Assets.xcassets
```

## Development Workflow

### 1. Daily Development

```bash
# Start development session
cd moonbar
source ~/.zshrc  # Ensure environment is loaded
open -a Xcode   # Launch Xcode with environment

# In Xcode:
# - Build: ⌘B
# - Run: ⌘R
# - Test: ⌘U
```

### 2. Git Workflow

```bash
# Create feature branch
git checkout -b feature/milestone-1-foundation

# Make changes and commit
git add .
git commit -m "feat(foundation): implement basic app structure

- Add AppDelegate with menu bar integration
- Configure LSUIElement for background app
- Set up basic project structure

Implements: Milestone 1 deliverables"

# Push and create PR
git push origin feature/milestone-1-foundation
```

### 3. Testing

#### Unit Tests
```bash
# Run all tests
⌘U in Xcode

# Or from command line
xcodebuild test -scheme Moonbar
```

#### Manual Testing
1. **Environment Test**: Verify API key is loaded
2. **Menu Bar Test**: App appears in menu bar, not dock
3. **API Test**: Successfully fetches balance
4. **Error Test**: Handles network failures gracefully

## Debugging

### Environment Issues

If environment variables aren't working:

```bash
# Check if variable is set
echo $MOONSHOT_API_KEY

# Check Xcode environment
# In Xcode: Product > Scheme > Edit Scheme > Run > Environment Variables
```

### API Issues

```bash
# Test API manually
curl -H "Authorization: Bearer $MOONSHOT_API_KEY" \
     https://api.moonshot.ai/v1/users/me/balance
```

### Common Issues

1. **"LSUIElement not working"**: Check Info.plist configuration
2. **"API key not found"**: Ensure Xcode launched from terminal
3. **"Menu bar not showing"**: Verify NSStatusBar implementation
4. **"Build errors"**: Check Swift version and deployment target

## Performance Monitoring

### Memory Usage
- Target: <10MB average
- Monitor in Xcode Instruments

### CPU Usage  
- Target: <1% average
- Check background timer efficiency

### Network Usage
- Target: <1KB per update
- Monitor API call frequency

## Code Quality

### Linting
```bash
# Install SwiftLint (optional)
brew install swiftlint

# Run linting
swiftlint
```

### Code Coverage
- Target: >90% for core logic
- View in Xcode Test Navigator

## Deployment

### Debug Builds
```bash
# Build for testing
xcodebuild -scheme Moonbar -configuration Debug
```

### Release Builds
```bash
# Build for distribution
xcodebuild -scheme Moonbar -configuration Release
```

## Troubleshooting

### Reset Development Environment

```bash
# Clean Xcode build
⌘⇧K in Xcode

# Reset git state
git clean -fd
git reset --hard HEAD

# Re-run setup
./setup-dev-env.sh
```

### Get Help

- 📖 **Documentation**: Check ARCHITECTURE.md and MILESTONES.md
- 🐛 **Issues**: Create GitHub issue
- 💬 **Discussions**: Use GitHub Discussions
- 📧 **Contact**: Reach out to maintainers

## Next Steps

1. ✅ **Environment Setup**: Complete this guide
2. 🏗️ **Create Xcode Project**: Follow the steps above
3. 🚀 **Start Milestone 1**: Begin implementing foundation
4. 🧪 **Write Tests**: Test as you develop
5. 📝 **Document**: Update docs as needed

Happy coding! 🌙✨