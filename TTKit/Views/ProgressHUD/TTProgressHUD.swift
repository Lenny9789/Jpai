import UIKit
#if canImport(SwiftTheme)
import SwiftTheme
#endif

fileprivate var refCount = Dictionary<Int, Int>()

/// Loading
///
open class TTProgressHUD: UIView {
    public static let shared = TTProgressHUD()

    /// 便捷配置函数
    open func setupCustom(_ block: @escaping (TTProgressHUD) -> Void) {
        block(self)
    }
    
    /// 弹窗背景色
    public var containerColor: TTColor = TTKitConfiguration.ProgressHUD.containerColor
    /// 弹窗圆角
    @objc public var containerCornerRadius: CGFloat = TTKitConfiguration.ProgressHUD.containerCornerRadius
    /// 只显示Loading时内容四周间距
    @objc public var indicatorEdgeInsets: UIEdgeInsets = TTKitConfiguration.ProgressHUD.indicatorEdgeInsets
    /// 显示Loading和文本时内容四周间距
    @objc public var indicatorTextEdgeInsets: UIEdgeInsets = TTKitConfiguration.ProgressHUD.indicatorTextEdgeInsets
    /// 文本字体
    @objc public var textFont: UIFont = TTKitConfiguration.ProgressHUD.textFont
    /// 文本颜色
    public var textColor: TTColor = TTKitConfiguration.ProgressHUD.textColor
    /// Loading和文本之间的间距
    @objc public var indicatorTextSpace: CGFloat = TTKitConfiguration.ProgressHUD.indicatorTextSpace

    
    internal var shadowView: UIView?
    internal var containerView: UIView?
    internal var vStackView: UIStackView?
    internal var activityIndicatorView: UIActivityIndicatorView?
    internal var loadingLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func showProgress(_ text: String? = nil, inView: UIView = kKeyWindow()!) {
        hideProgress()
        
        inView.addConstrained(subview: self)

        shadowView = UIView()
        shadowView!.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addConstrained(subview: shadowView!)
        
        containerView = UIView()
        switch containerColor {
        case .color(let color):
            containerView?.backgroundColor = color
        #if canImport(SwiftTheme)
        case .themeColor(let themeColor):
            containerView?.theme_backgroundColor = themeColor
        #endif
        }
        containerView!.setLayerCorner(radius: containerCornerRadius)
        addUnconstrained(subview: containerView!)
        NSLayoutConstraint.activate([
            containerView!.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView!.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        vStackView = UIStackView()
        vStackView!.axis = .vertical
        vStackView!.alignment = .center
        vStackView!.spacing = indicatorTextSpace
        
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView!.style = .white
        activityIndicatorView!.hidesWhenStopped = true
        activityIndicatorView!.startAnimating()

        if let text = text {
            containerView!.addConstrained(subview: vStackView!, top: indicatorTextEdgeInsets.top, left: indicatorTextEdgeInsets.left, bottom: indicatorTextEdgeInsets.bottom, right: indicatorTextEdgeInsets.right)
            
            loadingLabel = UILabel(text: text, font: textFont, color: textColor, lines: 0, align: .center)
            loadingLabel!.backgroundColor = .clear
            
            vStackView!.addArrangedSubview(activityIndicatorView!)
            vStackView!.addArrangedSubview(loadingLabel!)
        } else {
            containerView!.addConstrained(subview: vStackView!, top: indicatorEdgeInsets.top, left: indicatorEdgeInsets.left, bottom: indicatorEdgeInsets.bottom, right: indicatorEdgeInsets.right)
            
            vStackView!.addArrangedSubview(activityIndicatorView!)
        }
    }

    @objc public func hideProgress() {
        activityIndicatorView?.stopAnimating()
        if activityIndicatorView != nil {
            vStackView?.removeArrangedSubview(activityIndicatorView!)
        }
        if loadingLabel != nil {
            vStackView?.removeArrangedSubview(loadingLabel!)
        }
        vStackView?.removeFromSuperview()
        containerView?.removeFromSuperview()
        shadowView?.removeFromSuperview()
        removeFromSuperview()
        
        activityIndicatorView = nil
        loadingLabel = nil
        vStackView = nil
        containerView = nil
        shadowView = nil
    }
    
    @objc public static func show(_ text: String? = nil, inView: UIView = kKeyWindow()!) {
        mainQueueExecuting {
            /*guard (inView.allSubviews().contains(TTProgressHUD.shared)) == true else {
                TTProgressHUD.shared.showProgress(text, inView: inView)
                return
            }*/
            
            let viewAddrInt = unsafeBitCast(inView, to: Int.self)
            var count = refCount[viewAddrInt]
            if let count_ = count {
                count = count_ + 1
            } else {
                count = 1
            }
            refCount[viewAddrInt] = count
            
            if count == 1 {
                TTProgressHUD.shared.showProgress(text, inView: inView)
            }
        }
    }

    @objc public static func hide(_ forView: UIView = kKeyWindow()!) {
        mainQueueExecuting {
            /*guard (forView.allSubviews().contains(TTProgressHUD.shared)) == false else {
                TTProgressHUD.shared.hideProgress()
                return
            }*/
            
            let viewAddrInt = unsafeBitCast(forView, to: Int.self)
            var count = refCount[viewAddrInt]
            if let count_ = count {
                count = count_ - 1
                refCount[viewAddrInt] = count
                
                if count == 0 {
                    refCount.removeValue(forKey: viewAddrInt)
                    TTProgressHUD.shared.hideProgress()
                }
            }
        }
    }
}
