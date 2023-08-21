import UIKit

/// UIScrollView扩展活动指示器属性
///
extension UIScrollView {
    
    private struct AssociatedKey {
        static var identifier: UInt8 = 111
    }
    
    public var indicatorView: UIActivityIndicatorView { // actIndicatorView「实际上」是一个存储属性
        get {
            return tt_associatedObject(base: self, key: &AssociatedKey.identifier) { [weak self] in
                let view = UIActivityIndicatorView.init(style: .gray)
                view.hidesWhenStopped = true
                self?.addSubview(view)
                view.whc_Top(TTKitConfiguration.ScrollViewExp.indicatorTop)
                    .whc_CenterX(0)
                return view
            } // 设置变量的初始值
        }
        set {
            tt_associateObject(base: self, key: &AssociatedKey.identifier, value: newValue)
        }
    }
}
