import Foundation
import UIKit

class SideMenuShadow: NSObject {
    
    public var enabled: Bool = true {
        didSet {
            self.draw()
        }
    }
    public var color: UIColor = UIColor.black {
        didSet {
            self.draw()
        }
    }
    public var opacity: CGFloat = 0.75 {
        didSet {
            self.draw()
        }
    }
    public var radius: CGFloat = 10 {
        didSet {
            self.draw()
        }
    }
    
    public var shadowedView: UIView? {
        didSet {
            self.draw()
        }
    }
    
    public func draw() {
        
        if self.enabled {
            self.show()
        } else {
            self.hide()
        }
    }
    
    private func show() {
        if self.shadowedView == nil {
            return
        }
        var pathRect = self.shadowedView!.bounds
        pathRect.size = self.shadowedView!.frame.size
        self.shadowedView!.layer.shadowPath = UIBezierPath(rect: pathRect).cgPath
        self.shadowedView!.layer.shadowOpacity = Float(self.opacity)
        self.shadowedView!.layer.shadowRadius = self.radius
        self.shadowedView!.layer.shadowColor = self.color.cgColor
        self.shadowedView!.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func hide() {
        if self.shadowedView == nil {
            return
        }
        self.shadowedView!.layer.shadowOpacity = 0.0
        self.shadowedView!.layer.shadowRadius = 0.0
    }
    
    public class func shadow(sdView: UIView) -> SideMenuShadow {
        
        let smShadow = SideMenuShadow()
        smShadow.shadowedView = sdView
        return smShadow
    }
}
