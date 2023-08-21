import UIKit

/// 可设置UIButton图片、文字之间间距

open class TTSpaceButton: UIButton {
    var spacing : CGFloat? = 0
    
    override init(frame: CGRect) {
       super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(title: String, image: UIImage, space: CGFloat) {
        self.init()
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        spacing = space
    }
    
    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.titleRect(forContentRect: contentRect)
        rect.origin.x += spacing ?? 0
        return rect
    }
    
    @objc class func buttonWith(title: String, image: UIImage, space: CGFloat) -> TTSpaceButton{
        let button = TTSpaceButton(title: title, image: image, space: space)
        return button
    }
    
    open override func setImage(_ image: UIImage?, for state: UIControl.State) {
        let fixImage = image?.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        super.setImage(fixImage, for: state)
    }
}
