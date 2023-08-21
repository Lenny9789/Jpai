import UIKit

extension NSLayoutConstraint {
    /// Returns the `NSLayoutConstraint` with the priority set to the specified priority.
    ///
    /// - Parameter priority: The updated priority to set on the `NSLayoutConstraint`.
    ///
    /// - Returns: The `NSLayoutConstraint` with the priority set to the specified priority.
    ///
    public func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
