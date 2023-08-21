import UIKit
import UIKit.UIGestureRecognizerSubclass

open class TTAlertBaseTransitionGestureRecognizer: UIPanGestureRecognizer {
    
    // MARK: - Variables
    public weak var scrollView : UIScrollView?
    public var isFail : NSNumber?
    
    // MARK: - Initialization Method
    required override public init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        // Default Cancel Touches In View
        cancelsTouchesInView = false
    }
    
    // MARK: - Override Methods
    override open func reset()    {
        super.reset()
        isFail = nil
    }
}
