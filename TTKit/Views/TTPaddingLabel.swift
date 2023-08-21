import UIKit

/// 可设置UILabel文字周围间距
///
open class TTPaddingLabel: UILabel {
    
    private var edgeInsets: UIEdgeInsets = .zero

    public convenience init(_ edgeInsets: UIEdgeInsets) {
        self.init()
        self.edgeInsets = edgeInsets
    }

    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {

        var rect  = super.textRect(forBounds: bounds.inset(by: self.edgeInsets), limitedToNumberOfLines: numberOfLines)
        
        //根据edgeInsets，修改绘制文字的bounds
        rect.origin.x -= self.edgeInsets.left;
        rect.origin.y -= self.edgeInsets.top;
        rect.size.width += self.edgeInsets.left + self.edgeInsets.right;
        rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
        
        return rect;
    }
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.edgeInsets))
    }
}
