import UIKit
import WebKit
#if canImport(SwiftTheme)
import SwiftTheme
#endif

open class MainWebView: TTViewController, WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate {
    
    private var url: String!
    private var navTitle: String?
    private var isload: Bool = false
    
    lazy var config: WKWebViewConfiguration = {
        let user = WKUserContentController()
        user.add(self, name: "onSubmit_Code") //登录
        user.add(self, name: "sendCode")  //登录获取验证码
        user.add(self, name: "onSubmit")  //注册获取验证码
        user.add(self, name: "iOSApi")
        let conf = WKWebViewConfiguration()
        conf.userContentController = user
        return conf
    }()
    
    lazy var webView:WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: config)
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

extension MainWebView  {
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrintS("didFailProvisionalNavigation")
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("webWiew load success")
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("webWiew load failure")
    }
    
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
        return
    }
    
    public func userContentController(_ userContentController: WKUserContentController,
                                      didReceive message: WKScriptMessage) {
        debugPrintS(message)
    }
}
