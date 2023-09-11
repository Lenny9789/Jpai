import UIKit
import Lantern

class ContentBrowserImageCell: LanternImageCell {
    
    var tapClosure: (()->())?
    var panBeginClosure: (()->())?
    var panEndClosure: (()->())?
    var payClosure: (()->())?
    
    deinit {
        debugPrint("deinit - \(self.classForCoder)")
    }
    
    override func constructSubviews() {
        super.constructSubviews()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    /// 单击
    override func onSingleTap(_ tap: UITapGestureRecognizer) {
        tapClosure?()
    }
    
    /// 双击
    override func onDoubleTap(_ tap: UITapGestureRecognizer) {
        
        super.onDoubleTap(tap)
    }
    
    /// 响应拖动
    override func onPan(_ pan: UIPanGestureRecognizer) {
        
        super.onPan(pan)
        switch pan.state {
        case .began:
            self.panBeginClosure?()
        case .ended, .cancelled:
            let isDown = pan.velocity(in: self).y > 0
            if !isDown {
                self.panEndClosure?()
            }
        default:
            break
        }
    }
}
