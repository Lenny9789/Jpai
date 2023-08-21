import UIKit

extension UIFont {

    // MARK: Helper Methods

    /// Common font names defined.
    ///
    public enum FontName {
        static let pfscU = "PingFangSC-Ultralight"
        static let pfscT = "PingFangSC-Thin"
        static let pfscL = "PingFangSC-Light"
        static let pfscR = "PingFangSC-Regular"
        static let pfscM = "PingFangSC-Medium"
        static let pfscS = "PingFangSC-Semibold"
        static let pfscH = "PingFangSC-Heavy"
    }
    
    /// Returns a light `UIFont` instance with the specified fontSize.
    ///
    /// - Parameter fontSize: The  font size used to initialize the font.
    ///
    /// - Returns: The font instance.
    ///
    public static func fontLight(fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: UIFont.FontName.pfscL, size: fontSize) {
            return font
        } else {
            return UIFont.systemFont(ofSize: fontSize, weight: .light)
        }
    }
    
    /// Returns a regular `UIFont` instance with the specified fontSize.
    ///
    /// - Parameter fontSize: The  font size used to initialize the font.
    ///
    /// - Returns: The font instance.
    ///
    public static func fontRegular(fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: UIFont.FontName.pfscR, size: fontSize) {
            return font
        } else {
            return UIFont.systemFont(ofSize: fontSize, weight: .regular)
        }
    }
    
    /// Returns a medium `UIFont` instance with the specified fontSize.
    ///
    /// - Parameter fontSize: The  font size used to initialize the font.
    ///
    /// - Returns: The font instance.
    ///
    public static func fontMedium(fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: UIFont.FontName.pfscM, size: fontSize) {
            return font
        } else {
            return UIFont.systemFont(ofSize: fontSize, weight: .medium)
        }
    }
    
    /// Returns a semibold `UIFont` instance with the specified fontSize.
    ///
    /// - Parameter fontSize: The  font size used to initialize the font.
    ///
    /// - Returns: The font instance.
    ///
    public static func fontSemibold(fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: UIFont.FontName.pfscS, size: fontSize) {
            return font
        } else {
            return UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        }
    }
    
    /// Returns a bold `UIFont` instance with the specified fontSize.
    ///
    /// - Parameter fontSize: The  font size used to initialize the font.
    ///
    /// - Returns: The font instance.
    ///
    public static func fontBold(fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    /// Show system all fonts
    ///
    public static func showAllFonts() {
        let familyNames = UIFont.familyNames
        
        var index:Int = 0
        for familyName in familyNames {
            let fontNames = UIFont.fontNames(forFamilyName: familyName as String)
            for fontName in fontNames {
                index += 1
                print("index: \(index), fontName：\(fontName)")
            }
        }
    }
}

extension UIFont {
    
    /// Returns a scaled system `UIFont` instance with the specified text attributes.
    ///
    /// - Parameter attributes: The `TextAttributes` used to initialize the font.
    ///
    /// - Returns: The scaled font instance.
    ///
    public static func scaledFont(_ attributes: TextAttributes) -> UIFont {
        let font = UIFont.systemFont(ofSize: attributes.fontSize, weight: attributes.fontWeight)
        return font
        // Disable dynamic type
        //return UIFontMetrics(forTextStyle: attributes.fontTextStyle).scaledFont(for: font)
    }

    /// Returns a scaled monospaced digit system `UIFont` instance with the specified attributes.
    ///
    /// - Parameter attributes: The `TextAttributes` used to initialize the font.
    ///
    /// - Returns: The scaled monospaced digit font instance.
    ///
    public static func scaledMonospacedDigitFont(_ attributes: TextAttributes) -> UIFont {
        let font = UIFont.monospacedDigitSystemFont(ofSize: attributes.fontSize, weight: attributes.fontWeight)
        return font
        // Disable dynamic type
        //return UIFontMetrics(forTextStyle: attributes.fontTextStyle).scaledFont(for: font)
    }
}
