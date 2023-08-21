import UIKit
#if canImport(SwiftTheme)
import SwiftTheme
#endif

public enum TToastUtilsImageType {
    case success
    case fail
    case warning
}

class TToastUtils: Operation {

    private var _executing = false
    override open var isExecuting: Bool {
        get {
            return self._executing
        }
        set {
            self.willChangeValue(forKey: "isExecuting")
            self._executing = newValue
            self.didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _finished = false
    override open var isFinished: Bool {
        get {
            return self._finished
        }
        set {
            self.willChangeValue(forKey: "isFinished")
            self._finished = newValue
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    var textToastView: TTextToast = TTextToast()   // 纯文本
    var imageToastView: TTImageToast = TTImageToast()  // 含有图片
    
    var textMessage: String? {
        get { return self.textToastView.text }
        set { self.textToastView.text = newValue }
    }
    
    var imgMessage: String? {
        get { return self.imageToastView.text }
        set { self.imageToastView.text = newValue }
    }
    
    // 动画起始值
    var animationFromValue: CGFloat = 0
    var superComponent: UIView = UIView()
    var showSuccessToast: TToastUtilsImageType?
    var duration: CGFloat = 1.5  // 默认展示2秒
    var position = TToastPosition.middle

    init(msg: String, onView:UIView? = nil, success: TToastUtilsImageType? = nil, duration:CGFloat? = nil, position: TToastPosition? = .middle) {
        
        self.superComponent = onView ?? (UIApplication.shared.keyWindow ?? UIView())
        self.showSuccessToast = success
        self.duration = duration ?? 1.5
        self.position = position ?? TToastPosition.middle
        
        super.init()
        
        if self.showSuccessToast == nil {
            self.textMessage = msg
            self.textToastView.position = self.position
        } else {
            self.imgMessage = msg
            self.imageToastView.position = self.position
        }

        // 单利队列中每次都加入一个新建的Operation
        TToastManager.shared.add(self)
    }
    
    open override func cancel() {
        super.cancel()
        self.dismiss()
    }
    
    override func start() {
        let isRunnable = !self.isFinished && !self.isCancelled && !self.isExecuting
        guard isRunnable else { return }
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.start()
            }
            return
        }
        main()
    }
    
    override func main() {
        self.isExecuting = true
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            if self.showSuccessToast == nil {
                switch TToastManager.shared.textColor {
                case .color(let color):
                    self.textToastView.titleLabel.textColor = color
                #if canImport(SwiftTheme)
                case .themeColor(let themeColor):
                    self.textToastView.titleLabel.theme_textColor = themeColor
                #endif
                }
                self.textToastView.titleLabel.font = TToastManager.shared.textFont
                
                switch TToastManager.shared.bgColor {
                case .color(let color):
                    self.textToastView.backgroundColor = color
                #if canImport(SwiftTheme)
                case .themeColor(let themeColor):
                    self.textToastView.theme_backgroundColor = themeColor
                #endif
                }
                self.textToastView.layer.cornerRadius = TToastManager.shared.cornerRadius

                self.textToastView.setNeedsLayout()
                self.superComponent.addSubview(self.textToastView)
            } else {
                switch TToastManager.shared.textColor {
                case .color(let color):
                    self.imageToastView.titleLabel.textColor = color
                #if canImport(SwiftTheme)
                case .themeColor(let themeColor):
                    self.imageToastView.titleLabel.theme_textColor = themeColor
                #endif
                }
                self.imageToastView.titleLabel.font = TToastManager.shared.textFont
                switch TToastManager.shared.bgColor {
                case .color(let color):
                    self.imageToastView.backgroundColor = color
                #if canImport(SwiftTheme)
                case .themeColor(let themeColor):
                    self.imageToastView.theme_backgroundColor = themeColor
                #endif
                }
                self.imageToastView.layer.cornerRadius = TToastManager.shared.cornerRadius
                
                self.imageToastView.setNeedsLayout()
                self.superComponent.addSubview(self.imageToastView)
                if self.showSuccessToast == .success {
                    self.imageToastView.iconView.image = TToastManager.shared.successImage
                }
                if self.showSuccessToast == .fail {
                    self.imageToastView.iconView.image = TToastManager.shared.failImage
                }
                if self.showSuccessToast == .warning {
                    self.imageToastView.iconView.image = TToastManager.shared.warnImage
                }
            }
            
            let shakeAnimation = CABasicAnimation.init(keyPath: "opacity")
            shakeAnimation.duration = 0.5
            shakeAnimation.fromValue = self.animationFromValue
            shakeAnimation.toValue = 1
            shakeAnimation.delegate = self
            
            if self.showSuccessToast == nil {
                self.textToastView.layer.add(shakeAnimation, forKey: nil)
            } else {
                self.imageToastView.layer.add(shakeAnimation, forKey: nil)
            }
        }
    }
}

extension TToastUtils: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            UIView.animate(withDuration: 0.5, delay: TimeInterval(self.duration), options: UIView.AnimationOptions.allowUserInteraction, animations: { [weak self] in
                if self?.showSuccessToast == nil {
                    self?.textToastView.alpha = 0
                } else {
                    self?.imageToastView.alpha = 0
                }
            }) { [weak self] (finish) in
                self?.dismiss()
            }
        }
    }
    
    func dismiss() {
        self.textToastView.removeFromSuperview()
        self.imageToastView.removeFromSuperview()
        self.finish()
    }
    
    func finish() {
        self.isExecuting = false
        self.isFinished = true
        
        if TToastManager.shared.supportQueue == false {
            TToastManager.shared.cancelAll()
        }
    }
}
