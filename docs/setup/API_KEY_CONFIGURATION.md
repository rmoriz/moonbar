# API Key Configuration Guide

This guide explains how to configure your Moonshot API key for the Moonbar application.

## Overview

Moonbar needs your Moonshot API key to fetch balance information. The app uses a smart fallback system to find your API key, making it work seamlessly regardless of how you launch the application.

## Configuration Methods

### Method 1: Shell Configuration Files (Recommended)

This is the easiest and most reliable method. The app automatically reads your API key from shell configuration files.

#### For Zsh Users (macOS default)

Add this line to your `~/.zshrc` file:

```bash
export MOONSHOT_API_KEY="sk-your-actual-moonshot-api-key"
```

**To edit the file:**
```bash
nano ~/.zshrc
# Add the export line, then save with Ctrl+X, Y, Enter

# Reload your shell configuration
source ~/.zshrc
```

#### For Bash Users

Add this line to your `~/.bash_profile` or `~/.bashrc` file:

```bash
export MOONSHOT_API_KEY="sk-your-actual-moonshot-api-key"
```

**To edit the file:**
```bash
# For macOS (uses .bash_profile)
nano ~/.bash_profile

# For Linux or if you prefer .bashrc
nano ~/.bashrc

# Add the export line, then save with Ctrl+X, Y, Enter

# Reload your shell configuration
source ~/.bash_profile  # or source ~/.bashrc
```

### Method 2: Environment Variables

If you prefer to set environment variables directly:

```bash
export MOONSHOT_API_KEY="sk-your-actual-moonshot-api-key"
```

**Note:** This method only works when launching Xcode from the same terminal session:
```bash
open -a Xcode
```

## How the Fallback System Works

Moonbar uses a two-step process to find your API key:

1. **Environment Variables First**: Checks `ProcessInfo.processInfo.environment["MOONSHOT_API_KEY"]`
2. **Shell Config Fallback**: If not found, reads from these files in order:
   - `~/.zshrc`
   - `~/.bash_profile`
   - `~/.bashrc`
   - `~/.profile`

### Supported Export Formats

The app recognizes these export statement formats:

```bash
# With double quotes
export MOONSHOT_API_KEY="sk-your-api-key"

# With single quotes
export MOONSHOT_API_KEY='sk-your-api-key'

# Without quotes
export MOONSHOT_API_KEY=sk-your-api-key
```

## Verification

### Check Your Configuration

You can verify your API key is properly configured:

**From terminal:**
```bash
echo $MOONSHOT_API_KEY
```

**Check if the app can find it:**
When you run Moonbar, check the console output in Xcode for these messages:

- ✅ `"SUCCESS: Balance manager configured with Moonshot account"` - API key found and working
- 🔍 `"API key not found in environment, checking shell config files..."` - Using fallback
- ✅ `"SUCCESS: Found MOONSHOT_API_KEY in .zshrc"` - Found in shell config
- ❌ `"ERROR: MOONSHOT_API_KEY not found in environment or shell config"` - Not found

### Test API Key

You can test if your API key works:

```bash
curl -H "Authorization: Bearer $MOONSHOT_API_KEY" \
     https://api.moonshot.cn/v1/users/me
```

## Troubleshooting

### App Shows "❌" in Menu Bar

This usually means the API key is not found or invalid.

1. **Check your shell config file exists and has the export statement**
2. **Verify the API key format** (should start with `sk-`)
3. **Check file permissions** (should be readable by your user)
4. **Restart the app** after making changes

### API Key Not Found

If you see "ERROR: MOONSHOT_API_KEY not found":

1. **Verify the export statement syntax**
2. **Check you're editing the correct shell config file**
3. **Ensure no typos in the variable name** (`MOONSHOT_API_KEY`)
4. **Try the direct environment variable method** as a test

### Permission Issues

If the app can't read your shell config files:

```bash
# Check file permissions
ls -la ~/.zshrc ~/.bash_profile ~/.bashrc ~/.profile

# Fix permissions if needed
chmod 644 ~/.zshrc  # or whichever file you're using
```

## Security Notes

- **Never commit API keys to version control**
- **Keep your API key private and secure**
- **Use environment-specific keys for development vs production**
- **Regularly rotate your API keys**

## Getting Your API Key

1. Log in to your [Moonshot.ai account](https://moonshot.ai)
2. Navigate to API settings or developer console
3. Generate or copy your API key
4. It should start with `sk-` followed by a long string of characters

## Advanced Configuration

### Multiple Environments

You can use different API keys for different environments:

```bash
# In ~/.zshrc
export MOONSHOT_API_KEY_DEV="sk-dev-key-here"
export MOONSHOT_API_KEY_PROD="sk-prod-key-here"

# Use an alias to switch
alias moonbar-dev='export MOONSHOT_API_KEY=$MOONSHOT_API_KEY_DEV'
alias moonbar-prod='export MOONSHOT_API_KEY=$MOONSHOT_API_KEY_PROD'
```

### Using .env Files

While the app doesn't directly support .env files, you can source them:

```bash
# Create .env file
echo 'MOONSHOT_API_KEY="sk-your-key"' > .env

# Source it in your shell config
echo 'source /path/to/your/.env' >> ~/.zshrc
```

## Why This Approach?

macOS GUI applications (like those launched from Xcode or Finder) don't inherit environment variables from your shell by default. This fallback system ensures Moonbar works regardless of how it's launched:

- ✅ **Launched from Xcode**: Reads shell config files
- ✅ **Launched from Finder**: Reads shell config files  
- ✅ **Launched from terminal**: Uses environment variables or shell config
- ✅ **Distributed as standalone app**: Reads shell config files

This provides the best user experience without requiring complex setup procedures.