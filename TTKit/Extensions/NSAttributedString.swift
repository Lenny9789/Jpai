import UIKit

extension NSAttributedString {
    /// Returns the number of lines the attributed string takes.
    ///
    /// - Parameter size: The size of the area the attributed string is displayed in.
    ///
    /// - Returns: The number of lines the attributed string takes.
    ///
    public func lineCount(atSize size: CGSize) -> Int {
        let attrs = self.attributes(at: 0, effectiveRange: nil)
        guard let font = (attrs[NSAttributedString.Key.font] as? UIFont) else {
            return 0
        }
        let paragraph = attrs[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle
        let lineSpacing: CGFloat = paragraph?.lineSpacing ?? 0
        var fontMultiplyer: CGFloat = 1.0
        if let lineHeightMultiple = paragraph?.lineHeightMultiple, lineHeightMultiple > 0 {
            fontMultiplyer = lineHeightMultiple
        }

        // Calculate the height of a single line.
        let singleLineHeight = ceil(font.lineHeight * fontMultiplyer + lineSpacing)

        // Calculate the height of the text and divide it by the height of
        // a single line to get the total number of lines required to display
        // the text in the provided bounds.
        let textHeight = self.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).height
        return Int(ceil(textHeight / singleLineHeight))
    }

    /// Returns an `NSAttributedString` with the provided attributes.
    ///
    /// - Parameters:
    ///     - text: The text of the attributed string.
    ///     - textAlignment: The `NSTextAlignment` of the text.
    ///     - letterSpacing: The desired letter spacing between the characters of the string.
    ///     - lineSpacing: The desired line spacing of the body of text.
    ///     - font: The font of the text.
    ///     - textColor: The color of the text.
    ///
    /// - Returns: An `NSAttributedString` with the provided attributes.
    ///
    public static func stringWith(text: String? = nil,
                                  textAlignment: NSTextAlignment = .left,
                                  letterSpacing: CGFloat? = nil,
                                  lineSpacing: CGFloat? = nil,
                                  font: UIFont? = nil,
                                  textColor: UIColor? = nil) -> NSAttributedString? {
        guard let text = text else {
            return nil
        }

        let attributedString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: text.utf16.count)

        if let lineSpacing = lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.alignment = textAlignment
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        }

        if let letterSpacing = letterSpacing {
            attributedString.addAttribute(.kern, value: letterSpacing, range: range)
        }

        if let font = font {
            attributedString.addAttribute(.font, value: font, range: range)
        }

        if let color = textColor {
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }

        return attributedString
    }

    /// Returns an `NSAttributedString` with the provided attributes.
    ///
    /// - Parameters:
    ///     - text: The text of the attributed string.
    ///     - attributes: The `TextAttributes` of the string.
    ///     - textColor: The color of the text.
    ///
    /// - Returns: An `NSAttributedString` with the provided attributes.
    ///
    public static func stringWith(text: String? = nil,
                                  attributes: TextAttributes,
                                  textColor: UIColor? = nil) -> NSAttributedString? {
        return stringWith(text: text,
                          letterSpacing: attributes.letterSpacing,
                          lineSpacing: attributes.lineSpacing,
                          font: .scaledFont(attributes),
                          textColor: textColor)
    }

    /// If the number of lines required to display the string is greater than the provided number of lines,
    /// a new string with the provided truncation is returned. Otherwise, the original string is returned.
    ///
    /// - Parameters:
    ///     - truncation: The text to truncate the string with if the string requires truncation.
    ///     - maxNumberOfLines: The maximum number of lines before the string requires truncation.
    ///     - width: The width of the area the text is being displayed in.
    ///
    public func truncated(with truncation: NSAttributedString,
                          atLine maxNumberOfLines: Int,
                          width: CGFloat) -> NSAttributedString {

        // If the number of lines required to display the string is less than the max number of lines,
        // return the original string without truncation.
        if lineCount(atSize: CGSize(width: width, height: CGFloat.infinity)) <= maxNumberOfLines {
            return self
        }

        let result = NSMutableAttributedString()
        var lastEnd: Int = 0

        // 1. Enumerate through words.
        let nsString = (self.string as NSString)
        let stringRange = NSRange(location: 0, length: self.string.count)
        nsString.enumerateSubstrings(in: stringRange, options: .byWords) { [weak self] (_, range, enclosingRange, stop) in
            guard let `self` = self else { return }
            
            // 2. Add the word (without the whitespace) and the truncation string (ie. "... more") to the string.
            let rangeWithoutTrailingSpace = NSRange(location: enclosingRange.location,
                                                    length: range.upperBound - enclosingRange.location)
            result.append(self.attributedSubstring(from: rangeWithoutTrailingSpace))
            result.append(truncation)

            // 3. See if that attributed string is too many lines.
            if result.lineCount(atSize: CGSize(width: width, height: CGFloat.infinity)) > maxNumberOfLines {
                // 3a. If it is then delete the last word (and any whitespace before it)
                //     but leave the truncation string.

                // We need to delete to the end of the previous range and
                // then add the difference to the length of the range because
                // there can be multiple whitespace characters together
                let rangeToDelete = NSRange(location: lastEnd,
                                            length: rangeWithoutTrailingSpace.length +
                                                (rangeWithoutTrailingSpace.location - lastEnd))
                result.deleteCharactersSafely(in: rangeToDelete)
                stop.pointee = true
            } else {
                // 3b. If it is too short track the end of this (for sake of deleting whitespace on next pass),
                //     delete the word from the end and then add the word + whitespace and go back to #2
                lastEnd = rangeWithoutTrailingSpace.location + rangeWithoutTrailingSpace.length
                let deleteRange = NSRange(location: rangeWithoutTrailingSpace.location,
                                          length: rangeWithoutTrailingSpace.length + truncation.length)
                result.deleteCharactersSafely(in: deleteRange)
                result.append(self.attributedSubstring(from: enclosingRange))
            }
        }
        return result
    }
}

extension NSMutableAttributedString {

    /// Deletes as many characters in the given range as possible. If any part of `range` lies beyond
    /// the end of the receiver's characters, that part is ignored and no exception is thrown.
    ///
    /// - Parameter range: A range specifying the characters to delete.
    ///
    public func deleteCharactersSafely(in range: NSRange) {
        guard let clamped = range.intersection(NSRange(location: 0, length: length)) else {
            return
        }

        deleteCharacters(in: clamped)
    }
}
