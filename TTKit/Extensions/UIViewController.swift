import UIKit

extension UIViewController {

    /// Returns the topmost view controller starting from this view controller and navigating down
    /// the view hierarchy.
    ///
    /// - Returns: The topmost view controller from this view controller.
    ///
    public func topmostViewController() -> UIViewController {
        guard let presentedViewController = presentedViewController else { return self }

        if let navigationController = presentedViewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return visibleViewController.topmostViewController()
        } else if let tabBarController = presentedViewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return selectedViewController.topmostViewController()
        } else {
            return presentedViewController.topmostViewController()
        }
    }
}
