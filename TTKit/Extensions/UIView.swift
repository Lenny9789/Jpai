import UIKit
#if canImport(SwiftTheme)
import SwiftTheme
#endif

/// Helper functions  extended off the `UIView` class.
///
extension UIView {

    /// Add a subview, constrained to the specified top, left, bottom and right margins.
    ///
    /// - Parameters:
    ///   - view: The subview to add.
    ///   - top: Optional top margin constant.
    ///   - left: Optional left (leading) margin constant.
    ///   - bottom: Optional bottom margin constant.
    ///   - right: Optional right (trailing) margin constant.
    ///
    public func addConstrained(
        subview: UIView,
        top: CGFloat? = 0,
        left: CGFloat? = 0,
        bottom: CGFloat? = 0,
        right: CGFloat? = 0
    ) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)

        if let top = top {
            subview.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
        }
        if let left = left {
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: left).isActive = true
        }
        if let bottom = bottom {
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom).isActive = true
        }
        if let right = right {
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: right).isActive = true
        }
    }

    /// Add a subview with no constraints, with `translatesAutoresizingMaskIntoConstraints` set to false.
    ///
    /// - Parameter subview : The `UIView` to add as a subview.
    ///
    public func addUnconstrained(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
}

/// Frame properties extended off the `UIView` class.
///
extension UIView {
    
    /// x origin of view.
    public var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// y origin of view.
    public var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    /// Width of view.
    public var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    /// Height of view.
    public var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    /// Size of view.
    public var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }
    
    /// Origin of view.
    public var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame.origin = newValue
        }
    }
    
    /// CenterX of view.
    public var centerX: CGFloat {
        get {
            return center.x
        }
        set {
            center.x = newValue
        }
    }
    
    /// CenterY of view.
    public var centerY: CGFloat {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }
    
    /// Right of view.
    public var right: CGFloat {
        get {
            return frame.maxX
        }
        set {
            frame.origin.x = newValue - frame.size.width
        }
    }
    
    /// Bottom of view.
    public var bottom: CGFloat {
        get {
            return frame.maxY
        }
        set {
            frame.origin.y = newValue - frame.size.height
        }
    }
}

/// Computed properties extended off the `UIView` class.
///
extension UIView {
    
    /// This is the function to get subViews of a view of a particular type
    /// https://stackoverflow.com/a/45297466/5321670
    public func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }
    
    /// This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T
    /// https://stackoverflow.com/a/45297466/5321670
    public func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
    
    /// Returns an array of the subviews of a view, recursively.
    ///
    /// - Returns: An array of all the subviews of a view.
    ///
    public func allSubviews() -> [UIView] {
        guard subviews.count > 0 else { return [] }
        var views = subviews
        for view in views {
            let subviews = view.allSubviews()
            views.append(contentsOf: subviews)
        }
        return views
    }

    /// Returns an array of the subviews of a view of the given type, recursively.
    ///
    /// - Parameter type: The type of views returned, e.g. UILabel.self
    /// - Returns: An array of all the subviews of a view of `type`.
    ///
    public func allSubviews<T>(_ type: T.Type) -> [T] {
        return allSubviews().compactMap { $0 as? T}
    }
    
    public func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: T.self) }
    }
    
    public func searchVisualEffectsSubview() -> UIVisualEffectView? {
        if let visualEffectView = self as? UIVisualEffectView {
            return visualEffectView
        } else {
            for subview in subviews {
                if let found = subview.searchVisualEffectsSubview() {
                    return found
                }
            }
        }
        return nil
    }
    
    /// 寻找当前或任一父视图View是否包含指定tag
    ///
    public func isAnySuperViewTagEqual(to tag: NSInteger) -> Bool {
        if self.tag == tag {
            return true
        } else {
            if let view = self.superview {
                return view.isAnySuperViewTagEqual(to: tag)
            } else {
                return false
            }
        }
    }
}


/// Layer properties extended off the `UIView` class.
///
extension UIView {
    
    public typealias Configuration = (UIView) -> Swift.Void
    
    public func config(configurate: Configuration?) {
        configurate?(self)
    }
    
    //设置圆角、边框
    public func setLayerCorner(radius: CGFloat,
                               corners: CACornerMask = .allCorners,
                               width borderWidth: CGFloat? = nil,
                               color: TTCGColor? = nil) {
        layer.maskedCorners = corners
        layer.cornerRadius = radius
        if let borderWidth = borderWidth {
            layer.borderWidth = borderWidth;
        }
        if let color = color {
            switch color {
            case .cgColor(let cgColoor):
                layer.borderColor = cgColoor;
            #if canImport(SwiftTheme)
            case .themeCGColor(let themeCGColor):
                layer.theme_borderColor = themeCGColor
            #endif
            }
        }
        clipsToBounds = true
    }

    //去掉圆角、边框
    public func removeBorders() {
        layer.borderWidth = 0
        layer.cornerRadius = 0
        layer.borderColor = nil
    }
    
    
    /// Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    
    //设置右边框
    public func rightBorder(width: CGFloat, borderColor: UIColor){
        let rect = CGRect(x: 0, y: self.frame.size.width - width, width: width, height: self.frame.size.height)
        drawBorder(rect: rect, color: borderColor)
    }
    //设置左边框
    public func leftBorder(width: CGFloat, borderColor: UIColor){
        let rect = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        drawBorder(rect: rect, color: borderColor)
    }
    
    //设置上边框
    public func topBorder(width: CGFloat, borderColor: UIColor){
        let rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        drawBorder(rect: rect, color: borderColor)
    }
    
    //设置底边框
    public func bottomBorder(width: CGFloat, borderColor: UIColor){
        let rect = CGRect(x: 0, y: self.frame.size.height-width, width: self.frame.size.width, height: width)
        drawBorder(rect: rect, color: borderColor)
    }
    
    //画线
    private func drawBorder(rect:CGRect, color: UIColor){
        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = color.cgColor
        self.layer.addSublayer(lineShape)
    }
    
    
    /// 设置阴影效果
    public func setLayerShadow(radius: CGFloat,
                               corners: CACornerMask = .allCorners,
                               color: UIColor = .black,
                               offset: CGSize = CGSize(width:0, height:1),
                               shadowRadius: CGFloat = 10,
                               shadowOpacity: Float = 0.1) {
        //定义view的角度
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        //定义view的阴影颜色
        layer.shadowColor = color.cgColor
        //阴影偏移量
        layer.shadowOffset = offset
        //定义view的阴影宽度，模糊计算的半径
        layer.shadowRadius = shadowRadius
        //定义view的阴影透明度，注意:如果view没有设置背景色阴影也是不会显示的
        layer.shadowOpacity = shadowOpacity
        //针对圆角提升性能设置
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}


/// Gradient method extended of the `UIView` class.
///
extension UIView{
    
    ///设置渐变（支持背景色渐变、边框渐变）
    public func setGradient(
        size: CGSize,
        bgColors: [CGColor]? = nil,
        borderColors: [CGColor]? = nil,
        startPoint: CGPoint? = nil,
        endPoint: CGPoint? = nil,
        cornerRadius: CGFloat? = nil,
        borderWidth: CGFloat = 1,
        state: UIControl.State = .normal)
    {
        let tmpView = UIView()
        tmpView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        if let bgColors = bgColors {
            let gradientLayerBg: CAGradientLayer = CAGradientLayer()
            gradientLayerBg.colors = bgColors
            gradientLayerBg.startPoint = (startPoint != nil) ? startPoint! : CGPoint(x: 0.0, y: 0.5)
            gradientLayerBg.endPoint = (endPoint != nil) ? endPoint! : CGPoint(x: 1.0, y: 0.5)
            gradientLayerBg.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            if let cornerRadius = cornerRadius {
                gradientLayerBg.cornerRadius = cornerRadius
            }
            tmpView.layer.addSublayer(gradientLayerBg)
        }
        
        if let borderColors = borderColors {
            let gradientLayerBorder: CAGradientLayer = CAGradientLayer()
            gradientLayerBorder.colors = borderColors
            gradientLayerBorder.startPoint = (startPoint != nil) ? startPoint! : CGPoint(x: 0.0, y: 0.5)
            gradientLayerBorder.endPoint = (endPoint != nil) ? endPoint! : CGPoint(x: 1.0, y: 0.5)
            gradientLayerBorder.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            if let cornerRadius = cornerRadius {
                gradientLayerBorder.cornerRadius = cornerRadius
            }
            
            let maskLayer = CAShapeLayer()
            maskLayer.lineWidth = borderWidth
            if let cornerRadius = cornerRadius {
                maskLayer.path = UIBezierPath(roundedRect: CGRect(x: borderWidth, y: borderWidth, width: size.width-borderWidth*2, height: size.height-borderWidth*2), cornerRadius: cornerRadius).cgPath
                maskLayer.cornerRadius = cornerRadius
            } else {
                maskLayer.path = UIBezierPath(rect: CGRect(x: borderWidth, y: borderWidth, width: size.width-borderWidth*2, height: size.height-borderWidth*2)).cgPath
            }
            maskLayer.fillColor = UIColor.clear.cgColor
            maskLayer.strokeColor = UIColor.black.cgColor
            gradientLayerBorder.mask = maskLayer

            tmpView.layer.addSublayer(gradientLayerBorder)
        }
        
        if bgColors != nil || borderColors != nil  {
            let image = tmpView.asImage()

            if self is UIButton {
                let button  = self as! UIButton
                button.setBackgroundImage(image, for: state)
            } else if self is UIImageView {
                let imageView = self as! UIImageView
                imageView.image = image
            } else {
                self.backgroundColor = UIColor(patternImage: image)
            }
        }
    }
    
    ///移除渐变
    public func removeGradient(state: UIControl.State = .normal) {
        if self is UIButton {
            let button  = self as! UIButton
            button.setBackgroundImage(nil, for: state)
        } else if self is UIImageView {
            let imageView = self as! UIImageView
            imageView.image = nil
        } else {
            self.backgroundColor = .clear
        }
    }
    
    ///当前视图添加渐变图片
    public func asGradient(gradientLayer: CAGradientLayer,
                           state: UIControl.State = .normal) {
        let view = UIView()
        view.frame = self.bounds
        view.layer.addSublayer(gradientLayer)
        let image = view.asImage()
        
        if self is UIButton {
            let button  = self as! UIButton
            button.setBackgroundImage(image, for: state)
        } else if self is UIImageView {
            let imageView = self as! UIImageView
            imageView.image = image
        } else {
            self.backgroundColor = UIColor(patternImage: image)
        }
    }
    
    //将当前视图转为UIImage
    public func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
