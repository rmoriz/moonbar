import Foundation
import os.log

// MARK: - Logger

/// Centralized logging utility for Moonbar
/// Provides structured logging with different levels and categories
struct Logger {
    
    // MARK: - Log Categories
    
    enum Category: String, CaseIterable {
        case app = "App"
        case network = "Network"
        case balance = "Balance"
        case ui = "UI"
        case error = "Error"
        
        var osLog: OSLog {
            return OSLog(subsystem: "com.moriz.moonbar", category: self.rawValue)
        }
    }
    
    // MARK: - Log Levels
    
    enum Level {
        case debug
        case info
        case warning
        case error
        
        var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .warning:
                return .default
            case .error:
                return .error
            }
        }
        
        var emoji: String {
            switch self {
            case .debug:
                return "🔍"
            case .info:
                return "ℹ️"
            case .warning:
                return "⚠️"
            case .error:
                return "❌"
            }
        }
    }
    
    // MARK: - Static Methods
    
    /// Log a debug message
    static func debug(_ message: String, category: Category = .app, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, category: category, file: file, function: function, line: line)
    }
    
    /// Log an info message
    static func info(_ message: String, category: Category = .app, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, category: category, file: file, function: function, line: line)
    }
    
    /// Log a warning message
    static func warning(_ message: String, category: Category = .app, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, category: category, file: file, function: function, line: line)
    }
    
    /// Log an error message
    static func error(_ message: String, category: Category = .error, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, category: category, file: file, function: function, line: line)
    }
    
    /// Log an error with associated Error object
    static func error(_ error: Error, message: String? = nil, category: Category = .error, file: String = #file, function: String = #function, line: Int = #line) {
        let errorMessage = message ?? "Error occurred"
        let fullMessage = "\(errorMessage): \(error.localizedDescription)"
        log(fullMessage, level: .error, category: category, file: file, function: function, line: line)
    }
    
    // MARK: - Private Methods
    
    private static func log(_ message: String, level: Level, category: Category, file: String, function: String, line: Int) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let formattedMessage = "\(level.emoji) [\(category.rawValue)] \(message)"
        
        // Log to system log
        os_log("%{public}@", log: category.osLog, type: level.osLogType, formattedMessage)
        
        // Also print to console for development
        #if DEBUG
        let timestamp = DateFormatter.logFormatter.string(from: Date())
        print("\(timestamp) \(formattedMessage) (\(fileName):\(line) \(function))")
        #endif
    }
}

// MARK: - Extensions

extension DateFormatter {
    static let logFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}

// MARK: - Convenience Extensions

extension Logger {
    
    /// Log network request
    static func logNetworkRequest(_ request: URLRequest, category: Category = .network) {
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? "unknown"
        info("🌐 \(method) \(url)", category: category)
    }
    
    /// Log network response
    static func logNetworkResponse(_ response: URLResponse?, data: Data?, error: Error?, category: Category = .network) {
        if let error = error {
            self.error("🌐 Network request failed: \(error.localizedDescription)", category: category)
        } else if let httpResponse = response as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            let dataSize = data?.count ?? 0
            let emoji = statusCode >= 200 && statusCode < 300 ? "✅" : "❌"
            info("🌐 \(emoji) HTTP \(statusCode) (\(dataSize) bytes)", category: category)
        }
    }
    
    /// Log balance update
    static func logBalanceUpdate(provider: String, balance: String, category: Category = .balance) {
        info("💰 Balance updated for \(provider): \(balance)", category: category)
    }
    
    /// Log user interaction
    static func logUserInteraction(_ action: String, category: Category = .ui) {
        info("👆 User action: \(action)", category: category)
    }
    
    /// Log app lifecycle event
    static func logAppLifecycle(_ event: String, category: Category = .app) {
        info("🚀 App lifecycle: \(event)", category: category)
    }
}