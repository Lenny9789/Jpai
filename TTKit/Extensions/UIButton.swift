import UIKit

extension UIButton {

    /// Convience initializer to build a `UIButton`.
    ///
    /// - Parameters:
    ///   - text: Text to display for the button title. Defaults to nil.
    ///   - font: The font used to display the text.
    ///   - color: The color of the text.
    public convenience init(
        title: String? = nil,
        titleColor: UIColor,
        font: UIFont
    ) {
        self.init()

        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = font
    }

    /// Expands the clickable range of `UIButton`
    ///
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        //Gets the actual size of the current button.
        var bounds = self.bounds

        //If the original hot area is less than 44x44, enlarge the hot area, otherwise keep the original size unchanged.
        let widthDelta = max(44.0 - bounds.size.width, 0)
        let heightDelta = max(44.0 - bounds.size.height, 0)

        //Expand borders
        bounds = bounds.insetBy(dx: -0.5 * widthDelta, dy: -0.5 * heightDelta)

        //If the selected point is in the new boundaries, yes is returned.
        return bounds.contains(point) ? true : false
    }
}
