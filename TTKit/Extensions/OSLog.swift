import Foundation
import os.log

extension OSLog {

    // MARK: Type Properties

    /// OSLog instance for API logs.
    public static let api = OSLog(subsystem: subsystem, category: "API")

    /// OSLog instance for use by processors in the application.
    public static let processor = OSLog(subsystem: subsystem, category: "Processor")

    /// OSLog instance for used by Event Stream in the application.
    public static let sse = OSLog(subsystem: subsystem, category: "SSE")

    /// OSLog instance for used by Auth in the application.
    public static let auth = OSLog(subsystem: subsystem, category: "Auth")

    /// OSLog instance for used by Notifications in the application.
    public static let notifications = OSLog(subsystem: subsystem, category: "Notifications")

    // MARK: Private

    /// The OSLog subsystem passed along with logs to the logging system to identify logs from this
    /// application.
    public static var subsystem = Bundle.main.bundleIdentifier!
}
