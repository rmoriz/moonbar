import Cocoa

// Moonbar - AI Provider Balance Menu Bar App
// Entry point for the application

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// Configure app to run without dock icon
app.setActivationPolicy(.accessory)

// Start the application
app.run()