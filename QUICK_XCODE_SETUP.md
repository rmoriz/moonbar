# Quick Xcode Environment Setup

The automated scheme had an issue. Here's the manual fix:

## 🚀 Quick Manual Setup (2 minutes):

### **Step 1: Open Xcode**
```bash
open Moonbar.xcodeproj
```

### **Step 2: Edit Scheme**
1. Click "Moonbar" dropdown next to play button
2. Select "Edit Scheme..."
3. Select "Run" in left sidebar
4. Click "Environment Variables" tab
5. Click "+" to add:
   - **Name**: `MOONSHOT_API_KEY`
   - **Value**: `sk-your-actual-api-key`
   - **Enabled**: ✅ checked

### **Step 3: Test**
1. Build: ⌘B
2. Run: ⌘R
3. Check menu bar for balance!

## 🎯 Expected Results:

### **With Valid API Key:**
- Menu bar shows: `💡 12.34 $`
- Click cycles through: Available → Cash → Voucher
- Updates every 5 minutes

### **With Invalid API Key:**
- Menu bar shows: `Moonshot: ❌`
- Console shows authentication error

### **No API Key:**
- Menu bar shows: `Moonshot: ❌`
- Console shows missing API key error

## 🔍 Troubleshooting:

### **"Still getting accountNotFound":**
- Verify API key is set in scheme
- Make sure "Enabled" checkbox is checked
- Try clean build: ⌘⇧K then ⌘B

### **"Can't find scheme":**
- Use default scheme that Xcode creates
- Don't worry about the custom scheme file

### **"Network errors":**
- Test API key manually: `./test-api-connection.sh`
- Check internet connection

## ✅ Success Indicators:

1. **App builds** without errors
2. **Menu bar item** appears (no dock icon)
3. **Balance displays** or shows appropriate error
4. **Click interaction** works
5. **Console logs** show detailed operation info

The app is working perfectly - just needs the API key configured! 🎉