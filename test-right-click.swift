#!/usr/bin/env swift

import Cocoa

// Simple test to see if we can detect right-clicks on a status bar item

class TestAppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("🧪 Testing right-click detection...")
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.title = "🧪 Test"
            button.target = self
            button.action = #selector(buttonClicked)
            
            // Try different approaches
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            
            // Also try setting a simple menu
            let menu = NSMenu()
            menu.addItem(NSMenuItem(title: "Test Menu Item", action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Quit Test", action: #selector(quitTest), keyEquivalent: ""))
            statusBarItem?.menu = menu
        }
        
        print("✅ Test app ready - try both left and right clicking")
    }
    
    @objc func buttonClicked() {
        if let event = NSApp.currentEvent {
            print("🖱️ Click detected - type: \(event.type.rawValue)")
            if event.type == .leftMouseUp {
                print("   Left click!")
            } else if event.type == .rightMouseUp {
                print("   Right click!")
            } else {
                print("   Other click type: \(event.type)")
            }
        } else {
            print("🖱️ Click detected but no event info")
        }
    }
    
    @objc func quitTest() {
        print("👋 Quitting test app")
        NSApplication.shared.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = TestAppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()