import UIKit

/// An object used to group text attributes for a given display style.
///
public struct TextAttributes: Equatable {
    /// The size of the font.
    public var fontSize: CGFloat

    /// The text style of the font.
    public var fontTextStyle: UIFont.TextStyle

    /// The weight of the text font.
    public var fontWeight: UIFont.Weight

    /// The spacing between the letters.
    public var letterSpacing: CGFloat?

    /// The spacing between the lines.
    public var lineSpacing: CGFloat?
}

extension TextAttributes {

    /// Returns a new `TextAttributes` with the line spacing updated to the specified value.
    ///
    /// - Parameter lineSpacing: The new line spacing to update in the `TextAttributes`.
    /// - Returns: A new `TextAttributes` with the line spacing updated to the specified value.
    ///
    public func withLineSpacing(_ lineSpacing: CGFloat?) -> TextAttributes {
        TextAttributes(
            fontSize: fontSize,
            fontTextStyle: fontTextStyle,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            lineSpacing: lineSpacing
        )
    }
}
