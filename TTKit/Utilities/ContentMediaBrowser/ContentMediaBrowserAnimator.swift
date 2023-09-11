import UIKit

class ContentMediaBrowserAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var transitionImage: UIImage? {
        didSet {
            if let size = transitionImage?.size {
                var newSize: CGSize = .zero
                newSize.width = kScreenWidth
                newSize.height = newSize.width / size.width * size.height
                
                var imageY = (kScreenHeight - newSize.height) / 2
                if imageY < 0 {
                    imageY = 0
                }
                secondVCImageFrame = CGRect(x: 0, y: imageY, width: newSize.width, height: newSize.height)
            }
        }
    }
    
    var secondVCImageFrame: CGRect = .zero
    
    var firstVCImageFrame: CGRect = .zero
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.viewController(forKey: .to)!.view
        containerView.addSubview(toView!)
        toView?.alpha = 0.05
        
        let fromFrame = firstVCImageFrame
        let toFrame = secondVCImageFrame
        
        let transitionImageView = UIImageView()
        transitionImageView.image = transitionImage
        transitionImageView.layer.masksToBounds = true
        transitionImageView.contentMode = .scaleAspectFill
        transitionImageView.frame = fromFrame
        containerView.addSubview(transitionImageView)
        
        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.3,
            options: .curveLinear
        ) {
            var imageFrame = toFrame
            if imageFrame.size.width == 0 && imageFrame.size.height == 0 {
                let defaultWidth: CGFloat = 5
                imageFrame = CGRect(x: (kScreenWidth - defaultWidth)/2, y: (kScreenHeight - defaultWidth)/2, width: defaultWidth, height: defaultWidth)
            }
            transitionImageView.frame = imageFrame
            toView?.alpha = 1
            } completion: { finished in
                transitionImageView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
