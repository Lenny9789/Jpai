import UIKit

/// 可以设置text及leftView、rightView间距的TextField
///
open class TTSpaceTextField: UITextField {
    public var leftViewMargin: CGFloat?
    public var textLeftMargin: CGFloat?
    public var rightViewMargin: CGFloat?
    public var textRightMargin: CGFloat?

    /// Convenience init function
    ///
    /// - Parameters:
    ///     - leftViewMargin: leftView距父视图左侧间距.
    ///     - textLeftMargin: text距父视图左侧间距.
    ///     - rightViewMargin: rightView距父视图右侧侧间距.
    ///     - textRightMargin: text距父视图右侧间距.
    ///
    public convenience init(leftViewMargin: CGFloat?,
                            textLeftMargin: CGFloat?,
                            rightViewMargin: CGFloat?,
                            textRightMargin: CGFloat?) {
        self.init()
        
        self.leftViewMargin = leftViewMargin
        self.textLeftMargin = textLeftMargin
        self.rightViewMargin = rightViewMargin
        self.textRightMargin = textRightMargin
    }
    
    //UITextField leftView左间距
    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.leftViewRect(forBounds: bounds)
        if let leftViewMargin = self.leftViewMargin {
            iconRect.origin.x += leftViewMargin //向右边偏leftViewMargin
        }
        return iconRect
    }
    
    //UITextField rightView右间距
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.rightViewRect(forBounds: bounds)
        if let rightViewMargin = self.rightViewMargin {
            iconRect.origin.x -= rightViewMargin //向右边偏leftViewMargin
        }
        return iconRect
    }

    //UITextField 文字与输入框的距离
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        var leftIcon = super.leftViewRect(forBounds: bounds)
        if let _leftViewMargin = self.leftViewMargin {
            leftIcon.origin.x = _leftViewMargin
        }
        let clearIcon = super.clearButtonRect(forBounds: bounds)

        var textLeftMargin: CGFloat = leftIcon.origin.x+leftIcon.size.width
        var textRightMargin: CGFloat = bounds.size.width-clearIcon.origin.x
        if let _textLeftMargin = self.textLeftMargin {
            textLeftMargin = _textLeftMargin
        }
        if let _textRightMargin = self.textRightMargin {
            textRightMargin = _textRightMargin
        }
        return CGRect(x: textLeftMargin, y: bounds.origin.y, width: bounds.size.width-textLeftMargin-textRightMargin, height: bounds.size.height)
    }
    
    //控制文本的位置
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var leftIcon = super.leftViewRect(forBounds: bounds)
        if let _leftViewMargin = self.leftViewMargin {
            leftIcon.origin.x = _leftViewMargin
        }
        let clearIcon = super.clearButtonRect(forBounds: bounds)
        
        var textLeftMargin: CGFloat = leftIcon.origin.x + leftIcon.size.width
        var textRightMargin: CGFloat = bounds.size.width-clearIcon.origin.x
        if let _textLeftMargin = self.textLeftMargin {
            textLeftMargin = _textLeftMargin
        }
        if let _textRightMargin = self.textRightMargin {
            textRightMargin = _textRightMargin
        }
        return CGRect(x: textLeftMargin, y: bounds.origin.y, width: bounds.size.width-textLeftMargin-textRightMargin, height: bounds.size.height)
    }
}
