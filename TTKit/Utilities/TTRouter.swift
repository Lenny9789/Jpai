import UIKit

/*
 *  导航及页面相关操作
 */
public class TTRouter {
    public static let shared = TTRouter()
    
    /// 获取当前所在最上层控制器
    public func topViewController() -> UIViewController? {
        return topMost(of: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    /// 获取当前所在控制器
    public func currentViewController() -> UIViewController? {
        return topMost(of: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    /// 获取当前所在View
    public func currentView() -> UIView {
        let curVC = currentViewController()
        if curVC != nil {
            return curVC!.view
        } else {
            return kKeyWindow()!
        }
    }
    
    /// 获取当前所在导航栏
    public func currentNavigationController() -> UINavigationController? {
        let curVC = currentViewController()
        return curVC?.navigationController
    }
    
    /// 跳转下一个控制器
    public func pushViewController(_ viewController: UIViewController, hideBottomBar: Bool = true, animate: Bool = true) {
        let curNav = currentNavigationController()
        curNav?.pushViewController(viewController, animated: animate)
    }
    
    /// 返回上一级
    public func popViewController(animate: Bool = true) {
        let curNav = currentNavigationController()
        curNav?.popViewController(animated: animate)
    }
    
    /// 返回到指定控制器
    public func popToViewController(_ viewController: UIViewController, animate: Bool = false) {
        let curNav = currentNavigationController()
        if let controllers = curNav?.viewControllers, controllers.contains(viewController) {
            curNav?.popToViewController(viewController, animated: animate)
        }
    }
    
    /// 返回根目录
    public func popToRootViewController(animate: Bool = false) {
        let curNav = currentNavigationController()
        curNav?.popToRootViewController(animated: animate)
    }
    
    
    public func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        
        return viewController
    }
}
