import UIKit

@objc public protocol TTAlertInteractiveTransitionDelegate: AnyObject {
    @objc optional func alertViewControllerTransitionWillBegin(_ transition: TTAlertBaseInteractiveTransition)
    @objc optional func alertViewControllerTransitionWillFinish(_ transition: TTAlertBaseInteractiveTransition)
    @objc optional func alertViewControllerTransitionDidFinish(_ transition: TTAlertBaseInteractiveTransition)
    @objc optional func alertViewControllerTransitionWillCancel(_ transition: TTAlertBaseInteractiveTransition)
    @objc optional func alertViewControllerTransitionDidCancel(_ transition: TTAlertBaseInteractiveTransition)
}

open class TTAlertBaseInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    // MARK: - Declarations
    public enum TTAlertTransitionType : Int {
        case present = 0
        case dismiss
    }
    
    // MARK: - Variables
    // MARK: Public
    public weak var delegate : TTAlertInteractiveTransitionDelegate?
    public weak var modalViewController : UIViewController?
    public var transitionType : TTAlertTransitionType = .present
    public var transitionDuration : TimeInterval = 0.4
    public var gesture : TTAlertBaseTransitionGestureRecognizer?
    public var enableInteractiveTransition : Bool  {
        didSet {
            
            // Remove Existing Gesture
            removeGestureRecognizerFromModalController()
            
            if enableInteractiveTransition && (swipeGestureView != nil) {
                
                // Add New Gesture Recognizer
                let gestureRecognizerClass = classForGestureRecognizer() as TTAlertBaseTransitionGestureRecognizer.Type
                gesture = gestureRecognizerClass.init(target: self, action: #selector(handlePan(_:)))
                if let gesture = gesture    {
                    gesture.delegate = self
                    swipeGestureView?.addGestureRecognizer(gesture)
                }
            }
        }
    }
    public weak var swipeGestureView : UIView?  {
        didSet  {
            
            // Reload "enableInteractiveTransition" Property
            let enableInteractiveTransition = self.enableInteractiveTransition
            self.enableInteractiveTransition = enableInteractiveTransition
        }
    }
    public weak var contentScrollView: UIScrollView? {
        set {
            gesture?.scrollView = newValue
        }
        get {
            return gesture?.scrollView
        }
    }
    public var isInteracting : Bool = false
    public var panStartLocation : CGPoint?
    public var gestureRecognizerToFailPan : UIGestureRecognizer?
    public var transitionContext : UIViewControllerContextTransitioning?
    
    
    // MARK: - Initialization Methods
    public init(modalViewController: UIViewController,
                swipeGestureView: UIView?,
                contentScrollView: UIScrollView?)
    {
        // By Default Interactive Transition Is Turned On
        enableInteractiveTransition = true
        
        super.init()
        
        defer {
            // Set Default Values
            self.modalViewController = modalViewController
            self.swipeGestureView = swipeGestureView
            gesture?.scrollView = contentScrollView
        }
    }
    
    // MARK: - Helper Methods
    private func removeGestureRecognizerFromModalController() {
        if let gesture = gesture,
            let gestureRecognizers = swipeGestureView?.gestureRecognizers,
            gestureRecognizers.contains(gesture)
        {
            swipeGestureView?.removeGestureRecognizer(gesture)
            self.gesture = nil
        }
    }
    
    class public func valueBetween(start: CGFloat, andEnd end: CGFloat, forProgress currentProgress: CGFloat) -> CGFloat  {
        // Validation
        var progress = currentProgress
        if progress < 0.0 {
            progress = 0.0
        }
        else if progress > 1.0  {
            progress = 1.0
        }
        
        // Equation
        return start+((end-start)*progress)
    }
    
    
    // MARK: - Override Methods
    public func classForGestureRecognizer() -> TTAlertBaseTransitionGestureRecognizer.Type {
        return TTAlertBaseTransitionGestureRecognizer.self
    }
    
    public func updateUIState(transitionContext: UIViewControllerContextTransitioning,
                              percentComplete: CGFloat,
                              transitionType: TTAlertTransitionType)
    {
        // Override this method in child class to get desired output
    }
    
    
    // MARK: - Memory Management
    deinit {
        NotificationCenter.default.removeObserver(self)
        transitionContext = nil
    }
}


// MARK: - UIViewControllerTransitioningDelegate
extension TTAlertBaseInteractiveTransition: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?    {
        transitionType = .present
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?    {
        transitionType = .dismiss
        return self
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?   {
        return nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?  {
        // Return nil if we are not interacting
        if enableInteractiveTransition && isInteracting {
            transitionType = .dismiss
            return self
        }
        return nil
    }
}

extension TTAlertBaseInteractiveTransition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Override this method in child class to get desired output
    }
}


// MARK: - UIGestureRecognizerDelegate
extension TTAlertBaseInteractiveTransition: UIGestureRecognizerDelegate  {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let gestureRecognizerToFailPan = gestureRecognizerToFailPan,
            gestureRecognizerToFailPan == otherGestureRecognizer
        {
            return true
        }
        return false
    }
    
    // MARK: Pan Gesture Handle Methods
    @objc public func handlePan(_ recognizer: UIPanGestureRecognizer)  {
         // Override this method in child class to get desired output
    }
}


// MARK: - UIPercentDrivenInteractiveTransition
extension TTAlertBaseInteractiveTransition {
    
    open override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        // Update Transitioning Context
        self.transitionContext = transitionContext
        
        // Call Transition Will Begin Delegate
        delegate?.alertViewControllerTransitionWillBegin?(self)
    }
    
    open override func update(_ percentComplete: CGFloat) {
        
        // Update UI
        if let transitionContext = transitionContext {
            updateUIState(transitionContext: transitionContext,
                          percentComplete: 1.0 - percentComplete,
                          transitionType: transitionType)
        }
    }
    
    open override func finish() {
        
        // Validation
        guard let transitionContext = transitionContext else    {
            return
        }
        
        // Grab the from and to view controllers from the context
//        let duration = transitionDuration(using: transitionContext)
//        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        // Call Transition Will Finish Delegate
        delegate?.alertViewControllerTransitionWillFinish?(self)
        
        // Call Will System Methods
        fromViewController?.beginAppearanceTransition(false, animated: true)
        toViewController?.beginAppearanceTransition(true, animated: true)
        
        UIView.animate(withDuration: transitionDuration,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.0,
                       options: [.curveEaseOut, .beginFromCurrentState],
                       animations: { [weak self] in
                        
                        // Update UI
                        if let weakSelf = self, let transitionContext = weakSelf.transitionContext {
                            weakSelf.updateUIState(transitionContext: transitionContext,
                                                   percentComplete: 0.0,
                                                   transitionType: weakSelf.transitionType)
                        }
                        
        }) { [weak self] (finished) in
            
            // Call Did System Methods
            toViewController?.endAppearanceTransition()
            fromViewController?.endAppearanceTransition()
            
            // Complete Transition
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            // Call Transition Did Finish Delegate
            if let weakSelf = self  {
                weakSelf.delegate?.alertViewControllerTransitionDidFinish?(weakSelf)
            }
        }
    }
    
    open override func cancel() {
        
        // Validation
        guard let transitionContext = transitionContext else    {
            return
        }
        
        // Cancel Interactive Transition
        transitionContext.cancelInteractiveTransition()
        
        // Grab the from and to view controllers from the context
//        let duration = transitionDuration(using: transitionContext)
//        let containerView = transitionContext.containerView
//        let fromViewController = transitionContext.viewController(forKey: .from)
//        let toViewController = transitionContext.viewController(forKey: .to)
        
        // Call Will Cancel Delegate
        delegate?.alertViewControllerTransitionWillCancel?(self)
        
        UIView.animate(withDuration: transitionDuration,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.0,
                       options: [.curveEaseOut, .beginFromCurrentState],
                       animations: { [weak self] in
                        
                        // Update UI
                        if let weakSelf = self, let transitionContext = weakSelf.transitionContext {
                            weakSelf.updateUIState(transitionContext: transitionContext,
                                                   percentComplete: 1.0,
                                                   transitionType: weakSelf.transitionType)
                        }
                        
        }) { [weak self] (finished) in
            
            // Complete Transition
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            // Call Transition Did Cancel Delegate
            if let weakSelf = self  {
                weakSelf.delegate?.alertViewControllerTransitionDidCancel?(weakSelf)
            }
        }
    }
}


