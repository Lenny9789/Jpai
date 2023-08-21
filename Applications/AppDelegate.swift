import UIKit
import OpenIMSDK


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupApplication()
        
        let webview = MainWebView.init(url: "http://192.168.31.8:5173/login")
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        window?.rootViewController = webview
        window?.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate {
    
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
            TTKitConfiguration.ProgressHUD.containerColor = .color(.black)
            TTKitConfiguration.ProgressHUD.containerCornerRadius = 16
            
            /// `Toast`配置
            //            TTKitConfiguration.Toast.bgColor = .color(ThemeGuide.Colors.toastBg)
            
            /// `WebView`配置
            TTKitConfiguration.WebView.progressTint = .themeColor(ThemeGuide.Colors.theme_primary)
            TTKitConfiguration.WebView.progressTrack = .themeColor(ThemeGuide.Colors.theme_background)
        }
        
        GKConfigure.setupDefault()
        
    }
}
