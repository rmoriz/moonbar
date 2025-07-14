# Build and Run Guide

This guide covers different ways to build and run the Moonbar application, from GUI methods to fully automated command-line builds.

## Prerequisites

- **macOS 12.0 or later**
- **Xcode 14.0 or later**
- **Valid Moonshot API key** (see [API Key Configuration](API_KEY_CONFIGURATION.md))

## Quick Start

### 1. Configure API Key
First, set up your API key (this only needs to be done once):

```bash
# Add to your shell config file
echo 'export MOONSHOT_API_KEY="sk-your-actual-api-key"' >> ~/.zshrc
source ~/.zshrc
```

### 2. Clone and Build
```bash
# Clone the repository
git clone https://github.com/rmoriz/moonbar.git
cd moonbar

# Build and run
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Debug build
open ~/Library/Developer/Xcode/DerivedData/Moonbar-*/Build/Products/Debug/Moonbar.app
```

## Build Methods

### Method 1: Xcode GUI (Recommended for Development)

**Step 1: Open Project**
```bash
open Moonbar.xcodeproj
```

**Step 2: Configure Scheme (if needed)**
- Select "Moonbar" scheme from the dropdown
- Choose your target device (Mac)

**Step 3: Build and Run**
- Press `⌘R` to build and run
- Or use `⌘B` to build only

**Advantages:**
- Full IDE features (debugging, breakpoints, etc.)
- Easy to modify and test code
- Integrated console output

### Method 2: Command Line Build

#### Basic Build
```bash
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Debug build
```

#### Build and Run
```bash
# Build the project
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Debug build

# Run the built application
open ~/Library/Developer/Xcode/DerivedData/Moonbar-*/Build/Products/Debug/Moonbar.app
```

#### Build for Release
```bash
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Release build
```

#### Clean Build
```bash
# Clean previous builds
xcodebuild -project Moonbar.xcodeproj -target Moonbar clean

# Build fresh
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Debug build
```

### Method 3: Automated Build Script

Create a build script for repeated builds:

```bash
#!/bin/bash
# save as build.sh

set -e  # Exit on any error

echo "🔨 Building Moonbar..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
xcodebuild -project Moonbar.xcodeproj -target Moonbar clean

# Build the project
echo "🏗️ Building project..."
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Debug build

# Find the built app
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/Moonbar-*/Build/Products/Debug -name "Moonbar.app" -type d | head -1)

if [ -n "$APP_PATH" ]; then
    echo "✅ Build successful!"
    echo "📱 App location: $APP_PATH"
    
    # Optionally run the app
    read -p "🚀 Run the app now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🎯 Launching Moonbar..."
        open "$APP_PATH"
    fi
else
    echo "❌ Build failed - app not found"
    exit 1
fi
```

**Make it executable and use:**
```bash
chmod +x build.sh
./build.sh
```

## Build Configurations

### Debug Build (Default)
```bash
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Debug build
```

**Features:**
- Debug symbols included
- Optimizations disabled
- Console logging enabled
- Faster build times

### Release Build
```bash
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Release build
```

**Features:**
- Optimized for performance
- Smaller binary size
- Debug symbols stripped
- Production-ready

## Advanced Build Options

### Specify Build Location
```bash
# Build to specific directory
xcodebuild -project Moonbar.xcodeproj \
           -target Moonbar \
           -configuration Debug \
           -derivedDataPath ./build \
           build

# Run from specific location
open ./build/Build/Products/Debug/Moonbar.app
```

### Build with Specific SDK
```bash
# Use specific macOS SDK
xcodebuild -project Moonbar.xcodeproj \
           -target Moonbar \
           -sdk macosx \
           -configuration Debug \
           build
```

### Verbose Build Output
```bash
# See detailed build information
xcodebuild -project Moonbar.xcodeproj \
           -target Moonbar \
           -configuration Debug \
           -verbose \
           build
```

## Running the Application

### Method 1: Direct Launch
```bash
# Find and run the built app
open ~/Library/Developer/Xcode/DerivedData/Moonbar-*/Build/Products/Debug/Moonbar.app
```

### Method 2: Using App Path
```bash
# Store path in variable for reuse
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/Moonbar-*/Build/Products/Debug -name "Moonbar.app" -type d | head -1)
open "$APP_PATH"
```

### Method 3: Run from Custom Build Directory
```bash
# If you used custom derivedDataPath
open ./build/Build/Products/Debug/Moonbar.app
```

## Verification

### Check if App is Running
```bash
# Check if Moonbar is in the menu bar
ps aux | grep Moonbar | grep -v grep
```

### View Console Output
```bash
# View system logs for Moonbar
log stream --predicate 'process == "Moonbar"' --level debug
```

### Check App Info
```bash
# Get app information
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/Moonbar-*/Build/Products/Debug -name "Moonbar.app" -type d | head -1)
/usr/bin/mdls "$APP_PATH"
```

## Troubleshooting

### Build Fails

**"No target named 'Moonbar'"**
```bash
# List available targets and schemes
xcodebuild -project Moonbar.xcodeproj -list
```

**"Build input file cannot be found"**
```bash
# Clean and rebuild
xcodebuild -project Moonbar.xcodeproj -target Moonbar clean
xcodebuild -project Moonbar.xcodeproj -target Moonbar build
```

**Signing issues:**
```bash
# Build with ad-hoc signing
xcodebuild -project Moonbar.xcodeproj \
           -target Moonbar \
           CODE_SIGN_IDENTITY="-" \
           build
```

### App Won't Start

**Check API key configuration:**
```bash
echo $MOONSHOT_API_KEY
```

**Check app permissions:**
```bash
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/Moonbar-*/Build/Products/Debug -name "Moonbar.app" -type d | head -1)
ls -la "$APP_PATH/Contents/MacOS/Moonbar"
```

**Run with console output:**
```bash
# Run from terminal to see output
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/Moonbar-*/Build/Products/Debug -name "Moonbar.app" -type d | head -1)
"$APP_PATH/Contents/MacOS/Moonbar"
```

### Performance Issues

**Check build configuration:**
```bash
# Ensure you're using Debug for development
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Debug build

# Use Release for production
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Release build
```

## Continuous Integration

### GitHub Actions Example
```yaml
name: Build Moonbar
on: [push, pull_request]

jobs:
  build:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Build
      run: |
        xcodebuild -project Moonbar.xcodeproj \
                   -target Moonbar \
                   -configuration Release \
                   build
```

### Local CI Script
```bash
#!/bin/bash
# ci-build.sh - Local continuous integration

set -e

echo "🔄 Running CI build..."

# Clean
xcodebuild -project Moonbar.xcodeproj -target Moonbar clean

# Build Debug
echo "🔨 Building Debug..."
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Debug build

# Build Release  
echo "🔨 Building Release..."
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Release build

echo "✅ All builds successful!"
```

## Distribution

### Create App Bundle
```bash
# Build for release
xcodebuild -project Moonbar.xcodeproj -target Moonbar -configuration Release build

# Find the app
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/Moonbar-*/Build/Products/Release -name "Moonbar.app" -type d | head -1)

# Copy to Applications or create DMG
cp -R "$APP_PATH" /Applications/
```

### Archive for Distribution
```bash
# Create archive
xcodebuild -project Moonbar.xcodeproj \
           -target Moonbar \
           -configuration Release \
           archive \
           -archivePath ./Moonbar.xcarchive

# Export app
xcodebuild -exportArchive \
           -archivePath ./Moonbar.xcarchive \
           -exportPath ./export \
           -exportOptionsPlist ExportOptions.plist
```

This guide covers all the essential methods for building and running Moonbar. Choose the method that best fits your workflow and development needs.