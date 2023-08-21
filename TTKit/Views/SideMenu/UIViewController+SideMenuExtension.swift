import Foundation
import UIKit

public extension UIViewController {
    
    var menuContainerViewController: SideMenuContainerViewController {
        var containerVC = self
        while !containerVC.isKind(of: SideMenuContainerViewController.self) {
            if containerVC.responds(to: #selector(getter: parent)) {
                containerVC = containerVC.parent!
            }
        }
        return containerVC as! SideMenuContainerViewController
    }
}
