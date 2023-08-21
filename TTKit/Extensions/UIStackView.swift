import UIKit

extension UIStackView {
    /// Removes all arranged subviews and there constraints from the view.
    ///
    public func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
    }
}
