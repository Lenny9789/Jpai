import UIKit
import AudioToolbox

/// 带下滑关闭视图的底部弹框
///
open class TTSlidePopupView: UIView {
    // MARK: - Properties
    private let contentView: UIView
    private let isBgTranslucent: Bool
    private var viewDismissed: (() -> Void)?

    private var scrollView: UIScrollView?
    private var isDragScrollView: Bool = false
    private var lastTransitionY: CGFloat = 0
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(tapGesture:)))
        gesture.delegate = self;
        return gesture
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        gesture.delegate = self;
        return gesture
    }()
    
    // MARK: - Lifecycle
    public class func popupView(frame: CGRect = UIScreen.main.bounds,
                                contentView: UIView,
                                isBgTranslucent: Bool = true) -> TTSlidePopupView {
        return TTSlidePopupView(frame: frame, contentView: contentView, isBgTranslucent: isBgTranslucent)
    }
    
    public init(frame: CGRect, contentView: UIView, isBgTranslucent: Bool) {
        self.contentView = contentView
        self.isBgTranslucent = isBgTranslucent
        
        super.init(frame: frame)
        
        // 默认不展示内容视图
        var contentFrame = contentView.frame;
        contentFrame.origin.y = frame.size.height;
        self.contentView.frame = contentFrame;
        self.addSubview(self.contentView)
        
        // 添加手势
        self.addGestureRecognizer(self.tapGesture)
        self.addGestureRecognizer(self.panGesture)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    public func show(from: UIView = UIApplication.shared.firstKeyWindow!,
              completion: (() -> Void)? = nil,
              dismissed: (() -> Void)? = nil) {
        if let dismissed = dismissed {
            self.viewDismissed = dismissed
        }
        
        from.addSubview(self)
        
        AudioServicesPlaySystemSound(SystemSoundID(1520))

        showAnimate(completion: completion)
    }
    
    private func showAnimate(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear) { [weak self] in
            guard let `self` = self else { return }
            var frame = self.contentView.frame;
            frame.origin.y = self.frame.size.height - frame.size.height
            self.contentView.frame = frame
            
            if (self.isBgTranslucent) {
                self.backgroundColor = UIColor(hex: "0x000000", alpha: 0.3)
            }
        } completion: { (finished) in
            if let completion = completion {
                completion()
            }
        }
    }
    
    public func dismiss() {
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let `self` = self else { return }
            var frame = self.contentView.frame;
            frame.origin.y = self.frame.size.height;
            self.contentView.frame = frame;
        } completion: { [weak self] (finished) in
            self?.removeFromSuperview()
            
            if let viewDismissed = self?.viewDismissed {
                viewDismissed()
            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension TTSlidePopupView : UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (gestureRecognizer == self.panGesture) {
            var touchView = touch.view
            while (touchView != nil) {
                if touchView!.isKind(of: UIScrollView.self) {
                    self.scrollView = touchView as? UIScrollView
                    self.isDragScrollView = true
                    break;
                } else if (touchView == self.contentView) {
                    self.isDragScrollView = false
                    break;
                }
                touchView = touchView?.next as? UIView
            }
        }
        return true
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.tapGesture {
            let point = gestureRecognizer.location(in: self.contentView)
            if self.contentView.layer.contains(point) && gestureRecognizer.view == self {
                return false
            }
        } else if gestureRecognizer == self.panGesture {
            return true
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGesture {
            if otherGestureRecognizer.isKind(of: NSClassFromString("UIScrollViewPanGestureRecognizer")!) || otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
                if ((otherGestureRecognizer.view?.isKind(of: UIScrollView.self)) != nil) {
                    return true
                }
            }
        }
        return false
    }
}

// MARK: - Handle Gesture
extension TTSlidePopupView {
    @objc func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        let point = tapGesture.location(in: self.contentView)
        if !self.contentView.layer.contains(point) && tapGesture.view == self {
            dismiss()
        }
    }
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        guard let scrollView = self.scrollView else { return }
        
        let translation = panGesture.translation(in: self.contentView)
        if self.isDragScrollView {
            // 当UIScrollView在最顶部时，处理视图的滑动
            if scrollView.contentOffset.y <= 0 {
                if translation.y > 0 { // 向下拖拽
                    scrollView.contentOffset = .zero
                    scrollView.panGestureRecognizer.isEnabled = false
                    self.isDragScrollView = false
                    
                    var contentFrame = self.contentView.frame
                    contentFrame.origin.y += translation.y
                    self.contentView.frame = contentFrame
                }
            }
        } else {
            let contentM = (self.frame.size.height - self.contentView.frame.size.height);
            if translation.y > 0 { // 向下拖拽
                var contentFrame = self.contentView.frame
                contentFrame.origin.y += translation.y
                self.contentView.frame = contentFrame
            } else if (translation.y < 0 && self.contentView.frame.origin.y > contentM) { // 向上拖拽
                var contentFrame = self.contentView.frame;
                contentFrame.origin.y = max((self.contentView.frame.origin.y + translation.y), contentM);
                self.contentView.frame = contentFrame;
            }
        }
        
        panGesture.setTranslation(.zero, in: self.contentView)
        
        if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: self.contentView)
            
            scrollView.panGestureRecognizer.isEnabled = false
            
            // 结束时的速度>0 滑动距离> 5 且UIScrollView滑动到最顶部
            if (velocity.y > 0 && self.lastTransitionY > 5 && !self.isDragScrollView) {
                dismiss()
            } else {
                showAnimate(completion: nil)
            }
        }
        
        self.lastTransitionY = translation.y
        
        UIApplication.shared.firstKeyWindow?.endEditing(true)
    }
}
