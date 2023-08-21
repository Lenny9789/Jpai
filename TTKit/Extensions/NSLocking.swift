/*
 Abstract:
 An extension to `NSLocking` to simplify executing critical code.

 Adapted from Advanced NSOperations sample code in WWDC 2015 https://developer.apple.com/videos/play/wwdc2015/226/
 Adapted from https://developer.apple.com/sample-code/wwdc/2015/downloads/Advanced-NSOperations.zip
 */

import Foundation

extension NSLocking {

    /// Perform closure within lock.
    ///
    /// An extension to `NSLocking` to simplify executing critical code.
    ///
    /// - parameter block: The closure to be performed.

    public func withCriticalScope<T>(block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
