# Moonbar

A lightweight, native macOS menu bar application that displays your API balance from AI providers like Moonshot.ai directly in the macOS menu bar.

![Moonbar Screenshot](docs/moonbar.webp)

![macOS](https://img.shields.io/badge/macOS-12.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.7+-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

- 🌙 **Real-time Balance Display**: Shows your current API balance in the menu bar
- 🔄 **Auto-refresh**: Updates balance every 5 minutes automatically
- 🎯 **Native macOS Integration**: Runs quietly in the background, no dock icon
- 🌓 **Dark Mode Support**: Seamlessly integrates with macOS appearance
- 🔒 **Smart Updates**: Pauses when screen is locked to save battery
- 🔄 **Balance Type Switching**: Click to cycle through different balance types
- 🏗️ **Extensible Architecture**: Designed to support multiple AI providers

## Currently Supported Providers

- ✅ **Moonshot.ai** - Display available balance, cash balance, and voucher balance

## Planned Provider Support

- 🔄 **OpenAI** - GPT API credits
- 🔄 **Anthropic** - Claude API credits  
- 🔄 **Cohere** - API usage credits
- 🔄 **Google AI** - Gemini API credits

## Installation

### Prerequisites

- macOS 12.0 or later
- Xcode 14.0 or later (for building from source)
- Valid API key from supported provider

### From Source

1. Clone the repository:
   ```bash
   git clone https://github.com/rmoriz/moonbar.git
   cd moonbar
   ```

2. Set up your API key:
   ```bash
   export MOONSHOT_API_KEY="sk-your-api-key-here"
   ```

3. Open the project in Xcode:
   ```bash
   open Moonbar.xcodeproj
   ```

4. Build and run the project in Xcode

## Configuration

### API Key Setup

Moonbar supports multiple ways to configure your API key:

#### Option 1: Shell Configuration Files (Recommended)
Add your API key to your shell configuration file:

**For Zsh users (`~/.zshrc`):**
```bash
export MOONSHOT_API_KEY="sk-your-moonshot-api-key"
```

**For Bash users (`~/.bash_profile` or `~/.bashrc`):**
```bash
export MOONSHOT_API_KEY="sk-your-moonshot-api-key"
```

The app automatically reads from these files when launched from Xcode or Finder, so no additional setup is required.

#### Option 2: Environment Variables
If you prefer to use environment variables directly:

```bash
export MOONSHOT_API_KEY="sk-your-moonshot-api-key"
open -a Xcode  # Launch Xcode from terminal to inherit environment
```

#### Automatic Fallback
Moonbar uses a smart fallback system:
1. **First**: Checks environment variables
2. **Fallback**: Reads from shell config files (`~/.zshrc`, `~/.bash_profile`, `~/.bashrc`, `~/.profile`)

This ensures the app works regardless of how it's launched (Xcode, Finder, or terminal).

📖 **For detailed configuration instructions, see [API Key Configuration Guide](docs/setup/API_KEY_CONFIGURATION.md)**

## Usage

1. **Launch**: The app runs in the menu bar with no dock icon
2. **View Balance**: Your current balance appears as `💡 12.34 $`
3. **Switch Balance Types**: Click the menu bar item to cycle through:
   - Available Balance (primary)
   - Cash Balance
   - Voucher Balance
4. **Error States**: Shows `❌` when there are connection issues

## Architecture

Moonbar is built with a clean, extensible architecture:

- **Provider Protocol System**: Easy to add new AI providers
- **Account Management**: Ready for multiple accounts per provider
- **Normalized Balance Interface**: Consistent API across all providers
- **Thread-Safe Operations**: Reliable background updates
- **Native macOS Integration**: Uses AppKit for optimal performance

## Development

### Project Structure

```
Moonbar/
├── Sources/
│   ├── App/
│   │   ├── AppDelegate.swift
│   │   └── main.swift
│   ├── Models/
│   │   ├── Account.swift
│   │   ├── BalanceProvider.swift
│   │   └── MoonshotProvider.swift
│   ├── Services/
│   │   ├── BalanceManager.swift
│   │   └── BalanceFetcher.swift
│   └── Utilities/
├── Tests/
├── Resources/
└── Documentation/
```

### Building

#### Option 1: Using Xcode (GUI)
1. Ensure you have your API key configured (see Configuration section above)
2. Open `Moonbar.xcodeproj` in Xcode
3. Select the Moonbar scheme
4. Build and run (⌘R)

#### Option 2: Command Line Build
You can build and run Moonbar entirely from the command line:

**Build the project:**
```bash
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Debug build
```

**Build and run:**
```bash
# Build the app
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Debug build

# Run the built app
open ~/Library/Developer/Xcode/DerivedData/Moonbar-*/Build/Products/Debug/Moonbar.app
```

**Build for Release:**
```bash
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Release build
```

📖 **For comprehensive build instructions and troubleshooting, see [Build and Run Guide](docs/setup/BUILD_AND_RUN.md)**

### Testing

Run the test suite in Xcode:
```bash
⌘U
```

Or from command line:
```bash
xcodebuild test -scheme Moonbar
```

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](docs/development/CONTRIBUTING.md) for details.

### Adding New Providers

To add support for a new AI provider:

1. Implement the `BalanceProvider` protocol
2. Create provider-specific balance model conforming to `ProviderBalance`
3. Add provider to the registry
4. Write tests for the new provider

Example:
```swift
struct OpenAIProvider: BalanceProvider {
    let name = "OpenAI"
    let baseURL = "https://api.openai.com/v1"
    
    func fetchBalance(apiKey: String) async throws -> ProviderBalance {
        // Implementation
    }
}
```

## Roadmap

### MVP (Current)
- [x] Single Moonshot.ai account support
- [x] Menu bar integration
- [x] Auto-refresh functionality
- [x] Balance type switching

### Future Releases
- [ ] Multiple provider support (OpenAI, Anthropic, etc.)
- [ ] Multiple accounts per provider
- [ ] Preferences window
- [ ] Keychain integration for secure API key storage
- [ ] Low balance notifications
- [ ] Usage history and analytics

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Copyright

© 2025 Moriz GmbH

## Support

- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/rmoriz/moonbar/issues)
- 💡 **Feature Requests**: [GitHub Discussions](https://github.com/rmoriz/moonbar/discussions)
- 📧 **Contact**: [GitHub](https://github.com/rmoriz)

---

**Note**: This application requires valid API keys from supported providers. Please ensure you have appropriate access and understand the billing implications of API usage monitoring.