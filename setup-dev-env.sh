#!/bin/bash

# Moonbar Development Environment Setup Script
# This script helps set up the development environment for Moonbar

echo "🌙 Setting up Moonbar Development Environment"
echo "============================================="

# Check macOS version
echo "📱 Checking macOS version..."
sw_vers

# Check Xcode installation
echo ""
echo "🔨 Checking Xcode installation..."
if command -v xcodebuild &> /dev/null; then
    xcodebuild -version
    echo "✅ Xcode is installed"
else
    echo "❌ Xcode is not installed. Please install Xcode from the App Store."
    exit 1
fi

# Check Swift version
echo ""
echo "🦉 Checking Swift version..."
swift --version

# Check for required tools
echo ""
echo "🛠️  Checking development tools..."

if command -v git &> /dev/null; then
    echo "✅ Git is available: $(git --version)"
else
    echo "❌ Git is not installed"
fi

if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI is available: $(gh --version | head -1)"
else
    echo "⚠️  GitHub CLI is not installed (optional but recommended)"
fi

# Check environment variables
echo ""
echo "🔑 Checking environment variables..."

if [ -n "$MOONSHOT_API_KEY" ]; then
    echo "✅ MOONSHOT_API_KEY is set (${#MOONSHOT_API_KEY} characters)"
else
    echo "⚠️  MOONSHOT_API_KEY is not set"
    echo "   Please set it in your shell profile:"
    echo "   export MOONSHOT_API_KEY=\"sk-your-api-key-here\""
    echo ""
    echo "   Add this to your ~/.zshrc or ~/.bash_profile and restart your terminal"
fi

# Check project structure
echo ""
echo "📁 Checking project structure..."
if [ -f "README.md" ] && [ -f "ARCHITECTURE.md" ]; then
    echo "✅ Project documentation is present"
else
    echo "❌ Project files are missing. Make sure you're in the moonbar directory."
fi

# Recommendations
echo ""
echo "💡 Development Environment Recommendations:"
echo "   1. Use Xcode 15.0+ for best Swift 5.9+ support"
echo "   2. Set MOONSHOT_API_KEY environment variable"
echo "   3. Launch Xcode from terminal to inherit environment variables:"
echo "      open -a Xcode"
echo "   4. Consider using Xcode's built-in Git integration"
echo ""

# Next steps
echo "🚀 Next Steps:"
echo "   1. Set up your API key if not already done"
echo "   2. Create the Xcode project: 'File > New > Project > macOS > App'"
echo "   3. Configure project settings according to ARCHITECTURE.md"
echo "   4. Start implementing Milestone 1 from MILESTONES.md"
echo ""

echo "✨ Ready to build Moonbar! Happy coding! 🌙"