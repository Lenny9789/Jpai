import Lantern
import UIKit


fileprivate let containerHeight = 44.0
fileprivate let controlViewHeight = 50.0

class TMediaVideoCell: TVideoZoomCell {

    var tapClosure: (()->())?
    var panBeginClosure: (()->())?
    var panEndClosure: (()->())?

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
