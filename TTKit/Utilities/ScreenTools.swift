import UIKit

public typealias ScreenToolsClosure = (UIDeviceOrientation)->()

public class ScreenTools: NSObject {
    public static let share = ScreenTools()
    
    public var screenClosure: ScreenToolsClosure?
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiverNotification), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func receiverNotification(){
        let orient = UIDevice.current.orientation
        
//        switch orient {
//        case .portrait :
//            kScreenWidth = UIScreen.main.bounds.width
//            kScreenHeight = UIScreen.main.bounds.height
//            if self.screenClosure != nil {
//                self.screenClosure!(.portrait)
//            }
//            break
//        case .portraitUpsideDown:
//            kScreenWidth = UIScreen.main.bounds.width
//            kScreenHeight = UIScreen.main.bounds.height
//            if self.screenClosure != nil {
//                self.screenClosure!(.portraitUpsideDown)
//            }
//            break
//        case .landscapeLeft:
//            kScreenWidth = UIScreen.main.bounds.width
//            kScreenHeight = UIScreen.main.bounds.height
//            if self.screenClosure != nil {
//                self.screenClosure!(.landscapeLeft)
//            }
//            break
//        case .landscapeRight:
//            kScreenWidth = UIScreen.main.bounds.width
//            kScreenHeight = UIScreen.main.bounds.height
//            if self.screenClosure != nil {
//                self.screenClosure!(.landscapeRight)
//            }
//            break
//        default:
//            break
//        }
    }
}
