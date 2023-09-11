#if canImport(ESPullToRefresh)

import UIKit
import ESPullToRefresh

open class AwesomeRefreshFooterAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {
    
    public var indicatorStyle: TTIndicatorStyle = .style(UIActivityIndicatorView.Style.medium) {
        didSet  {
            switch indicatorStyle {
            case .style(let style):
                indicatorView.style = style
            case .themeStyle(let themeStyle):
                indicatorView.theme_activityIndicatorViewStyle = themeStyle
            }
        }
    }

    open var view: UIView { return self }
    open var duration: TimeInterval = 0.3
    open var insets: UIEdgeInsets = UIEdgeInsets.zero
    open var trigger: CGFloat = 82.0
    open var executeIncremental: CGFloat = 42.0
    open var state: ESRefreshViewState = .pullToRefresh
    
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(indicatorView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func refreshAnimationBegin(view: ESRefreshComponent) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
    }
    
    open func refreshAnimationEnd(view: ESRefreshComponent) {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
    }
    
    open func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // do nothing
    }
    
    open func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .refreshing, .autoRefreshing :
            break
        case .noMoreData:
            break
        case .pullToRefresh:
            break
        default:
            break
        }
        self.setNeedsLayout()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = self.bounds.size
        let w = s.width
        let h = s.height
        
        indicatorView.center = CGPoint.init(x: w / 2.0, y: h / 2.0)
    }
}

#endif
