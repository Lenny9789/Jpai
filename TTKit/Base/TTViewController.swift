import UIKit
import RxSwift

/// 记录上一个导航显示的`ViewController`名称
public var tt_lastClassName: String = ""

open class TTViewController: UIViewController {
    public var disposeBag = DisposeBag()
    
    /// deinit
    deinit {
        debugPrintS("🟠🟠🟠🟠🟠🟠🟠🟠🟠 \(ttClassName) 已经释放了 🟠🟠🟠🟠🟠🟠🟠🟠🟠")
    }
    
    /// 视图Appear时的时间戳
    open var appearTimeStamp: TimeInterval?
    
    /// 当前控制器是否正在显示
    open var isCurrentControllerVisible: Bool = false
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isCurrentControllerVisible = true
        
        appearTimeStamp = Date().timeIntervalSince1970

#if DEBUG
        if TTKitConfiguration.General.isShowDebugController {
            let noteLabel = TTDebuger.shared.noticeLabel;
            if noteLabel.superview == nil {
                noteLabel.bringSubviewToFront(noteLabel)
            }
            noteLabel.text = " [\(TTDebuger.shared.customNote) ]:\(ttClassName)"
        }
#endif
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        isCurrentControllerVisible = false
        
        tt_lastClassName = ttClassName
    }
    
    
    /// 本视图打开之前，导航栏是否隐藏
    open var isPreviousNavigationBarHidden: Bool?
    
    /// 隐藏/显示导航栏
    open func hideNavigationBar(_ hide: Bool) {
        if hide {
            if isPreviousNavigationBarHidden == nil {
                isPreviousNavigationBarHidden = navigationController?.isNavigationBarHidden
            }
            navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            if let barHidden = isPreviousNavigationBarHidden {
                navigationController?.setNavigationBarHidden(barHidden, animated: false)
            }
        }
    }
}
