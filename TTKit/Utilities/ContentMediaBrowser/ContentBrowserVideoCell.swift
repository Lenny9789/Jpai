import UIKit
import Lantern

class ContentBrowserVideoCell: TVideoZoomCell {
    
    var tapClosure: (()->())?
    var panBeginClosure: (()->())?
    var panEndClosure: (()->())?
    var payClosure: (()->())?
    
    override func constructSubviews() {
        super.constructSubviews()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    deinit {
        debugPrint("deinit - \(self.classForCoder)")
    }
    
    /// 单击
    override func onSingleTap(_ tap: UITapGestureRecognizer) {
       
        tapClosure?()
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
