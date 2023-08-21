import UIKit
#if canImport(SwiftTheme)
import SwiftTheme
#endif

extension UITextField {
    public func themePlaceholder(_ placeholder: String, colorValues:[String], font: UIFont) {
        #if canImport(SwiftTheme)
        self.attributedPlaceholder = NSAttributedString(string: placeholder)

        let titleAttributes = colorValues.map { hexString in
            return [
                NSAttributedString.Key.foregroundColor: UIColor(rgba: hexString),
                NSAttributedString.Key.font: font
            ]
        }
        self.theme_placeholderAttributes = ThemeStringAttributesPicker.pickerWithAttributes(titleAttributes)
        #endif
    }
}
