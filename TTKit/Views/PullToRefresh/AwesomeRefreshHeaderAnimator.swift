#if canImport(ESPullToRefresh)

import UIKit
import ESPullToRefresh

open class AwesomeRefreshHeaderAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol, ESRefreshImpactProtocol {

    public var arrowImage: UIImage? {
        didSet  {
            imageView.image = arrowImage
        }
    }
    
    public var indicatorStyle: TTIndicatorStyle = .style(.gray) {
        didSet  {
            switch indicatorStyle {
            case .style(let style):
                indicatorView.style = style
            case .themeStyle(let themeStyle):
                indicatorView.theme_activityIndicatorViewStyle = themeStyle
            }
        }
    }
    
    public var view: UIView { return self }
    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var trigger: CGFloat = 60.0
    public var executeIncremental: CGFloat = 60.0
    public var state: ESRefreshViewState = .pullToRefresh

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        let frameworkBundle = Bundle(for: ESRefreshAnimator.self)
        if let path = frameworkBundle.path(forResource: "ESPullToRefresh", ofType: "bundle"),let bundle = Bundle(path: path) {
            imageView.image = UIImage(named: "icon_pull_to_refresh_arrow", in: bundle, compatibleWith: nil)
        } else if let bundle = Bundle.init(identifier: "com.eggswift.ESPullToRefresh") {
            imageView.image = UIImage(named: "icon_pull_to_refresh_arrow", in: bundle, compatibleWith: nil)
        } else if let bundle = Bundle.init(identifier: "org.cocoapods.ESPullToRefresh") {
            imageView.image = UIImage(named: "ESPullToRefresh.bundle/icon_pull_to_refresh_arrow", in: bundle, compatibleWith: nil)
        } else {
            imageView.image = UIImage(named: "icon_pull_to_refresh_arrow")
        }
        return imageView
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(indicatorView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        imageView.isHidden = true
        imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
    }
  
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
        imageView.isHidden = false
        imageView.transform = CGAffineTransform.identity
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // Do nothing
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .refreshing, .autoRefreshing:
            self.setNeedsLayout()
            break
        case .releaseToRefresh:
            self.setNeedsLayout()
            self.impact()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: { [weak self] in
                self?.imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
            }) { (animated) in }
            break
        case .pullToRefresh:
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: { [weak self] in
                self?.imageView.transform = CGAffineTransform.identity
            }) { (animated) in }
            break
        default:
            break
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let s = self.bounds.size
        let w = s.width
        let h = s.height
        
        let imgSize = imageView.image!.size
        
        UIView.performWithoutAnimation {
            indicatorView.center = CGPoint.init(x: w / 2.0, y: h / 2.0)
            imageView.frame = CGRect.init(x: (w - imgSize.width) / 2.0, y: (h - imgSize.height) / 2.0, width: imgSize.width, height: imgSize.height)
        }
    }
}

#endif
