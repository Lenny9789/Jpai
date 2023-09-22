//
//  AppControllerTransitioningManager.swift
//  minghaimuyuan

import UIKit

class AppControllerTransitioningManager: NSObject, UIViewControllerTransitioningDelegate {

    static let shared = AppControllerTransitioningManager()
    
    var popType: PopKinds = .sexSelect
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AppPopAnimationManager(type: .dismiss, popKinds: popType)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AppPopAnimationManager(type: .present, popKinds: popType)
    }
}

class AppPopAnimationManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let animateDuration: TimeInterval = 0.3
    
    enum TransitionType {
        case  present, dismiss
    }
    
    init(type: TransitionType, popKinds: PopKinds) {
        self.type = type
        self.popKinds = popKinds
    }
    
    private var type: TransitionType = .present
    private var popKinds: PopKinds = .sexSelect
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animateDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .present:
            switch popKinds {
            
            case .sexSelect, .dateSelect:
                let containerView = transitionContext.containerView
                let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
                containerView.addSubview(toView!)
                
                let backView = toView?.viewWithTag(1101)
                backView?.alpha = 0
                let contentView = toView?.viewWithTag(1102)
                contentView?.transform = CGAffineTransform.init(translationX: 0, y: PopSexSelectView.viewHeight)
                
                UIView.animate(withDuration: animateDuration) {
                    backView?.alpha = 1
//                    contentView?.alpha = 0
                    contentView?.transform = CGAffineTransform.identity
                } completion: { _ in
                    transitionContext.completeTransition(true)
                }
            }
            
        case .dismiss:
            switch popKinds {
            
                
            case .sexSelect, .dateSelect:
                let fromView = transitionContext.view(forKey: .from)!
                
                let backView = fromView.viewWithTag(1101)
                let contentView = fromView.viewWithTag(1102)
                
                UIView.animate(withDuration: animateDuration) {
                    backView?.alpha = 0
                    contentView?.alpha = 0
                    contentView?.transform = CGAffineTransform.init(translationX: 0, y: contentView!.height)
                } completion: { _ in
                    transitionContext.completeTransition(true)
                }
            }
        }
    }
}

