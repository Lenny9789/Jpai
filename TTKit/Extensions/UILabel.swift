import UIKit
#if canImport(SwiftTheme)
import SwiftTheme
#endif

extension UILabel {
    /// Convenience initializer to build a `UILabel`.
    ///
    /// - Parameters:
    ///   - text: Text to display in the label. Defaults to nil.
    ///   - font: The font used to display the text.
    ///   - color: The color of the text.
    ///   - lines: The maximum number of lines to display. Defaults to `0`.
    ///   - align: The technique used for aligning the text. Defaults to `left`.
    ///   - mode: The technique used for wrapping and truncating the label's text. Defaults
    ///     to `byWordWrapping`.
    ///
    public convenience init(text: String? = nil,
                            font: UIFont,
                            color: TTColor,
                            lines: Int = 0,
                            align: NSTextAlignment = .left,
                            mode: NSLineBreakMode = .byWordWrapping
    ) {
        self.init()

        adjustsFontForContentSizeCategory = true
        self.text = text
        self.font = font
        switch color {
        case .color(let color):
            self.textColor = color
        #if canImport(SwiftTheme)
        case .themeColor(let themeColor):
            self.theme_textColor = themeColor
        #endif
        }
        self.numberOfLines = lines
        self.textAlignment = align
        self.lineBreakMode = mode
    }
}

extension UILabel {
    /// Sets the `attributedText` on the label with the provided attributes.
    ///
    /// - Parameters:
    ///   - text: Text to display in the label. Defaults to nil.
    ///   - attributes: The `TextAttributes` associated with label's font.
    ///   - color: The color of the text.
    ///   - isMonospacedDigitFont: A boolean indicating if the font should be a monospaced digit font.
    ///
    public func setText(_ text: String? = nil,
                        with attributes: TextAttributes,
                        color: UIColor? = nil,
                        isMonospacedDigitFont: Bool = false) {
        let font: UIFont = isMonospacedDigitFont ? .scaledMonospacedDigitFont(attributes) : .scaledFont(attributes)
        attributedText = NSAttributedString.stringWith(text: text,
                                                       textAlignment: textAlignment,
                                                       letterSpacing: attributes.letterSpacing,
                                                       lineSpacing: attributes.lineSpacing,
                                                       font: font,
                                                       textColor: color ?? textColor)
    }
}
