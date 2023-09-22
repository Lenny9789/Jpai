import UIKit
import OpenIMSDK


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupApplication()
        let initSuccess = MessageManager.shared.setupMessageManager()
        if initSuccess {
            self.enterTabController()

        }
        
        // 初始化SDK
//        IMController.shared.setup(sdkAPIAdrr: kApiAddress,
//                                  sdkWSAddr: kWsAddress,
//                                  sdkOS: "minio") {
//            IMController.shared.currentUserRelay.accept(nil)
////            AccountViewModel.saveUser(uid: nil, imToken: nil, chatToken: nil)
////            NotificationCenter.default.post(name: .init("logout"), object: nil)
//        }
//        enterTabController()
        return true
    }
}

extension AppDelegate {
    
    func enterTabController() {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarController.shared
        window?.makeKeyAndVisible()
    }
    
    func enterLoginController() {
        let webview = MainWebView.init(url: localDebugIP)
        let nav = UINavigationController(rootVC: webview)
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
//        OpenIMSDK.OIMManager.callbacker.addAdvancedMsgListener(listener: webview)
    }
    
    
    func setupApplication() {
        /// `TTKit` 全局配置
        TTKitConfiguration.setupConfig {
            /// `General`配置
            TTKitConfiguration.General.isShowDebugController = true
            TTKitConfiguration.Networking.timeoutIntervalForResource = 300
            TTKitConfiguration.Networking.timeoutIntervalForRequest = 300
            /// `HTTP`配置
            // 是否打印请求log
            TTKitConfiguration.Networking.isShowRequestLog = true
            
            /// `Loading`配置
            TTKitConfiguration.ProgressHUD.containerColor = .color(.init(white: 0, alpha: 0.8))
            TTKitConfiguration.ProgressHUD.containerCornerRadius = 16
            
            /// `Toast`配置
            TTKitConfiguration.Toast.bgColor = .color(ThemeGuide.Colors.toastBg)
            
            /// `WebView`配置
            TTKitConfiguration.WebView.progressTint = .themeColor(ThemeGuide.Colors.theme_primary)
            TTKitConfiguration.WebView.progressTrack = .themeColor(ThemeGuide.Colors.theme_background)
        }
        
        GKConfigure.setupDefault()
        
    }
}
