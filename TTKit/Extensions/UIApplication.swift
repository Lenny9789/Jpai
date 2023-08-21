import UIKit

/// Helper functions and computed properties extended off the `UIApplication` class.
///
extension UIApplication {
    /// Returns the first window in `windows` that is a key window.
    public var firstKeyWindow: UIWindow? {
        return windows.first { $0.isKeyWindow }
    }
}
