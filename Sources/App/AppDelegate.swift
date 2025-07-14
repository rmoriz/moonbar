import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Properties
    
    private var statusBarItem: NSStatusItem?
    private var balanceManager: BalanceManager?
    private var refreshTimer: Timer?
    
    // MARK: - Application Lifecycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupStatusBarItem()
        setupBalanceManager()
        setupRefreshTimer()
        
        // Initial balance fetch
        fetchBalance()
        
        // Setup screen lock/unlock notifications
        setupScreenLockNotifications()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        cleanupResources()
    }
    
    // MARK: - Status Bar Setup
    
    private func setupStatusBarItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let statusBarItem = statusBarItem else {
            print("❌ Failed to create status bar item")
            return
        }
        
        // Configure button
        if let button = statusBarItem.button {
            button.title = "💡 Loading..."
            button.target = self
            button.action = #selector(statusBarButtonClicked)
            
            // Enable both left and right mouse events
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        // Create and assign the context menu directly
        let menu = createContextMenu()
        statusBarItem.menu = menu
        
        print("✅ Status bar item created with context menu")
    }
    
    // MARK: - Context Menu Setup
    
    private func createContextMenu() -> NSMenu {
        let menu = NSMenu()
        
        // Balance info (will be updated dynamically)
        let balanceItem = NSMenuItem(title: "Balance: Loading...", action: nil, keyEquivalent: "")
        balanceItem.tag = 100 // Tag for easy identification
        menu.addItem(balanceItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Refresh action
        let refreshItem = NSMenuItem(title: "Refresh Now", action: #selector(refreshBalance), keyEquivalent: "r")
        refreshItem.target = self
        menu.addItem(refreshItem)
        
        // About info
        let aboutItem = NSMenuItem(title: "About Moonbar", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit option
        let quitItem = NSMenuItem(title: "Quit Moonbar", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        return menu
    }
    
    private func updateBalanceInMenu(_ balanceText: String) {
        // This method is no longer needed since we create the menu dynamically
    }
    
    private func updateBalanceInContextMenu(_ menu: NSMenu) {
        guard let balanceItem = menu.item(withTag: 100) else { return }
        
        // Get current balance from the status bar button
        let currentBalance = statusBarItem?.button?.title ?? "Loading..."
        balanceItem.title = "Balance: \(currentBalance)"
    }
    
    // MARK: - Balance Management
    
    private func setupBalanceManager() {
        balanceManager = BalanceManager()
        balanceManager?.delegate = self
        print("✅ Balance manager initialized")
    }
    
    private func fetchBalance() {
        balanceManager?.updateBalance()
    }
    
    // MARK: - Timer Management
    
    private func setupRefreshTimer() {
        // Refresh every 5 minutes (300 seconds)
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 300.0, repeats: true) { [weak self] _ in
            self?.fetchBalance()
        }
        print("✅ Refresh timer started (5 minute intervals)")
    }
    
    // MARK: - Screen Lock Detection
    
    private func setupScreenLockNotifications() {
        let notificationCenter = DistributedNotificationCenter.default()
        
        // Screen lock notification
        notificationCenter.addObserver(
            self,
            selector: #selector(screenDidLock),
            name: NSNotification.Name("com.apple.screenIsLocked"),
            object: nil
        )
        
        // Screen unlock notification
        notificationCenter.addObserver(
            self,
            selector: #selector(screenDidUnlock),
            name: NSNotification.Name("com.apple.screenIsUnlocked"),
            object: nil
        )
        
        print("✅ Screen lock notifications configured")
    }
    
    // MARK: - Event Handlers
    
    @objc private func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        // For left-click, cycle balance types
        // Right-click will automatically show the menu (handled by macOS)
        print("🖱️ Status bar button clicked")
        balanceManager?.switchBalanceType()
    }
    
    @objc private func refreshBalance() {
        print("🔄 Manual refresh requested")
        balanceManager?.updateBalance()
    }
    
    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "Moonbar"
        alert.informativeText = """
        A lightweight macOS menu bar app for monitoring AI provider API balances.
        
        Version: 1.0
        Copyright © 2025 Moriz GmbH
        
        Currently monitoring: Moonshot.ai
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    @objc private func quitApp() {
        print("👋 Quitting Moonbar...")
        cleanupResources()
        NSApplication.shared.terminate(nil)
    }
    
    @objc private func screenDidLock() {
        refreshTimer?.invalidate()
        print("🔒 Screen locked - pausing updates")
    }
    
    @objc private func screenDidUnlock() {
        setupRefreshTimer()
        fetchBalance() // Immediate update when unlocked
        print("🔓 Screen unlocked - resuming updates")
    }
    
    // MARK: - Cleanup
    
    private func cleanupResources() {
        refreshTimer?.invalidate()
        refreshTimer = nil
        
        DistributedNotificationCenter.default().removeObserver(self)
        
        print("✅ Resources cleaned up")
    }
}

// MARK: - BalanceManagerDelegate

extension AppDelegate: BalanceManagerDelegate {
    
    func balanceManager(_ manager: BalanceManager, didUpdateBalance balance: String) {
        DispatchQueue.main.async { [weak self] in
            self?.statusBarItem?.button?.title = balance
        }
    }
    
    func balanceManager(_ manager: BalanceManager, didEncounterError error: AppError) {
        DispatchQueue.main.async { [weak self] in
            let errorDisplay = "Moonshot: ❌"
            self?.statusBarItem?.button?.title = errorDisplay
            print("❌ Balance error: \(error)")
        }
    }
}