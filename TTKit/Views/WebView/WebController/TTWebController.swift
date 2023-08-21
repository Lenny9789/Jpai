import UIKit
import WebKit
#if canImport(SwiftTheme)
import SwiftTheme
#endif

open class TTWebController: TTViewController, WKUIDelegate {

    private var url: String!
    private var navTitle: String?
    private var isload: Bool = false
    
    lazy var webView:WKWebView = {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.allowsBackForwardNavigationGestures = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 9.0, *) {
            webView.allowsLinkPreview = false
        }
        
        // 网页有透明的情况，所以这里还是设置了颜色
        switch TTKitConfiguration.General.backgroundColor {
        case .color(let color):
            webView.scrollView.backgroundColor = color
        #if canImport(SwiftTheme)
        case .themeColor(let themeColor):
            webView.scrollView.theme_backgroundColor = themeColor
        #endif
        }
        
        return webView
    }()
    
    lazy private var progressView: UIProgressView = {
        self.progressView = UIProgressView.init(frame: CGRect.zero)
       
        switch TTKitConfiguration.WebView.progressTint {
        case .color(let color):
            self.progressView.tintColor = color
        #if canImport(SwiftTheme)
        case .themeColor(let themeColor):
            self.progressView.theme_tintColor = themeColor
        #endif
        }
        
        switch TTKitConfiguration.WebView.progressTrack {
        case .color(let color):
            self.progressView.trackTintColor = color
        #if canImport(SwiftTheme)
        case .themeColor(let themeColor):
            self.progressView.theme_trackTintColor = themeColor
        #endif
        }
        return self.progressView
    }()
    
    deinit {
        webView.navigationDelegate = nil
        webView.scrollView.delegate = nil
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
    }
    
    convenience init(url: String, title: String? = nil) {
        self.init()
        self.url = url
        self.navTitle = title
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadRequest(urlStr: self.url)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupViews() {
        switch TTKitConfiguration.General.backgroundColor {
        case .color(let color):
            view.backgroundColor = color
        #if canImport(SwiftTheme)
        case .themeColor(let themeColor):
            view.theme_backgroundColor = themeColor
        #endif
        }
        gk_navBackgroundImage = kMainNavBackImage
        gk_navLineHidden = true
        if let navTitle = self.navTitle {
            gk_navTitle = navTitle
        }
        
        view.addSubview(webView)
        view.addSubview(progressView)
        webView.whc_AutoSize(left: 0, top: kNavBarHeight, right: 0, bottom: 0)
        progressView.whc_Top(0)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Height(2)
    }
    
    private func loadRequest(urlStr:String) {
        var urlString = urlStr
        if !urlStr.contains("http://") && !urlStr.contains("https://") && !urlStr.contains("file://"){
            urlString = "https://" + urlStr
        }
        let url = URL(string: urlString)
        if let url = url {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    private func updateProgress(_ progress: Double) {
        progressView.alpha = 1.0
        progressView.setProgress(Float((progress) ), animated: true)
        if progress  >= 1.0 {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: { [weak self] in
                self?.progressView.alpha = 0
            }, completion: { [weak self] (finish) in
                self?.progressView.setProgress(0.0, animated: false)
            })
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "title":
            if self.navTitle == nil {
                self.navigationItem.title = self.webView.title
            }
        case "estimatedProgress":
            self.updateProgress(self.webView.estimatedProgress)
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            break
        }
    }

}

extension TTWebController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("webWiew load success")
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("webWiew load failure")
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard var urlString = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        
        /* 支付宝支付 */
        /*if urlString.hasPrefix("alipays://") ||
            urlString.hasPrefix("alipay://") ||
            urlString.range(of: "?pay=") != nil {
            guard TTKitConfiguration.General.aliPayScheme != "" else {
                fatalError("Please config `aliPayScheme`")
            }
            //  1.以？号来切割字符串
            let urlBaseArr = urlString.components(separatedBy: "?")
            guard let urlBaseStr = urlBaseArr.first,
                  let urlNeedDecode = urlBaseArr.last else {
                decisionHandler(.cancel)
                return
            }
            //  2.将截取以后的Str，做一下URLDecode，方便我们处理数据
            let afterDecodeStr = urlNeedDecode.urlDecoded
            //  3.替换里面的默认Scheme为自己的Scheme
            let afterHandleStr = afterDecodeStr.replacingOccurrences(of: "alipays", with: TTKitConfiguration.General.aliPayScheme)
            //  4.然后把处理后的，和最开始切割的做下拼接，就得到了最终的字符串
            //let finalStr = "\(String(describing: urlBaseStr))?\(afterHandleStr.urlEncode)"
            let finalStr = "\(String(describing: urlBaseStr))?\(afterHandleStr)"

            delayExecuting(0.5) {
                guard let payUrl = URL(string: finalStr) else {
                    return
                }

                //  判断一下，是否安装了支付宝APP
                if (UIApplication.shared.canOpenURL(payUrl)) {
                    debugPrint("打开支付宝：\(payUrl)")
                    UIApplication.shared.openURL(payUrl)
                } else {
                    //未安装支付宝
                    UIAlertController.showAlertWithTitle(
                        title: .localized_tips_kit,
                        message: .localized_uninstall_alipay,
                        items: [(.localized_install_now, .cancel)]
                    ) { index in
                        let downloadStr = "https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8"
                        if let downloadUrl = URL(string: downloadStr) {
                            if (UIApplication.shared.canOpenURL(downloadUrl)) {
                                UIApplication.shared.openURL(downloadUrl)
                            }
                        }
                    }
                }
                self.isload = true
            }

            decisionHandler(.cancel)
            return
        }*/
        
        /* 微信支付 */
        //1.拦截第一次,并在webview重新加载,拦截的目的是为了换我们自己的redirect_url
       /* if urlString.range(of: "https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb") != nil && !self.isload {
            guard TTKitConfiguration.General.weChatScheme != "" else {
                fatalError("Please config `weChatScheme`")
            }
            decisionHandler(.cancel)
            // 替换掉redirect_url
            urlString = urlString.replacingOccurrences(of: "redirect_url=", with: "redirect_url_app=")
            if let newURLS = URL(string: urlString) {
                var mRequest = URLRequest.init(url: newURLS, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
                mRequest.setValue("\(TTKitConfiguration.General.weChatScheme)://", forHTTPHeaderField: "Referer")
                webView.load(mRequest)
                self.isload = true
                return
            }
        }*/
        //2.发现weixin://wap/pay开头的链接,说明是微信支付的链接,拦截下来并唤起APP
       /* if urlString.range(of: "weixin://wap/pay?") != nil {
            guard let payUrl = URL(string: urlString) else {
                return
            }
            
            self.isload = false
            decisionHandler(.cancel)

            if (UIApplication.shared.canOpenURL(payUrl)) {
                debugPrint("打开支微信：\(payUrl)")
                UIApplication.shared.openURL(payUrl)
                /*// 回到上一级页面
                // 1.防止因为load上面的微信支付url而出现的白屏
                // 2.防止停留在支付宝支付确认页面
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.webView.canGoBack {
                        self.webView.goBack()
                    }
                }*/
            } else {
                //未安装微信
                UIAlertController.showAlertWithTitle(
                    title: .localized_tips_kit,
                    message: .localized_uninstall_wechat,
                    items: [(.localized_install_now, .cancel)]
                ) { index in
                    let downloadStr = "https://itunes.apple.com/cn/app/wei/id414478124?mt=8"
                    if let downloadUrl = URL(string: downloadStr) {
                        if (UIApplication.shared.canOpenURL(downloadUrl)) {
                            UIApplication.shared.openURL(downloadUrl)
                        }
                    }
                }
            }
            return
        }*/
        
        self.isload = false
        decisionHandler(.allow)
        return
    }
}
