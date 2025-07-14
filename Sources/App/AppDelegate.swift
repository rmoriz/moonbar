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
        }
        
        print("✅ Status bar item created")
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
    
    @objc private func statusBarButtonClicked() {
        balanceManager?.switchBalanceType()
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