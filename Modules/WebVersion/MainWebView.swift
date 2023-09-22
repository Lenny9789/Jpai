import UIKit
import WebKit
import AliRTCSdk

open class MainWebView: TTViewController, WKUIDelegate, WKNavigationDelegate {
    
    private var url: String!
    private var navTitle: String?
    private var isload: Bool = false
    private let disposebag = DisposeBag()
    
    lazy var config: WKWebViewConfiguration = {
        let user = WKUserContentController()
        
        user.add(self, name: "send2iOSApi")
//        user.add(self, name: "console")
        user.add(self, name: "jumpActivity")
//        user.addUserScript(WKUserScript(source: "console.log = function(message) { window.webkit.messageHandlers.console.postMessage(message); }", injectionTime: .atDocumentStart, forMainFrameOnly: true))
        user.add(self, name: "androidApi")
        let conf = WKWebViewConfiguration()
        conf.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        conf.userContentController = user
        return conf
    }()
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: config)
        
        webView.isOpaque = false
        webView.backgroundColor = .white
        webView.allowsBackForwardNavigationGestures = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 9.0, *) {
            webView.allowsLinkPreview = false
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
    
    lazy var recordingView: RecorderView = {
        let view = RecorderView()
        return view
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        if url != nil {
            loadRequest(urlStr: self.url)
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isShop {
            loadLocals()
            webView.evaluateJavaScript("window.location.href='index.html#/shop'")
        }
        if isPayment {
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    private func setupViews() {
        gk_navigationBar.isHidden = true
        
        view.addSubview(webView)
        view.addSubview(progressView)
        webView.whc_AutoSize(left: 0, top: kStatusBarHeight, right: 0, bottom: 0)
        progressView.whc_Top(kStatusBarHeight)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Height(2)
        

        if isPayment {
            webView.whc_RemoveAttrs(.top)
                .whc_Top(kStatusAndNavBarHeight)
            progressView.whc_RemoveAttrs(.top)
                .whc_Top(kStatusAndNavBarHeight)
            
            gk_navigationBar.isHidden = false
            gk_statusBarHidden = false
        }
        
        NotificationCenter.default.rx.notification(TTNotifyName.App.OIMSDKLoginSuccess)
            .subscribe { [weak self] _ in
                guard let `self` = self else { return }
                guard self.isShop else { return }
                
                self.webView.reload()
            }.disposed(by: disposeBag)
    }
    
    func loadRequest(urlStr:String) {
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
    
    func loadLocals() {
        let url = Bundle.main.url(forResource: "dist/index", withExtension: "html")
        webView.loadFileURL(url!, allowingReadAccessTo: Bundle.main.bundleURL)
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
    
    lazy var textF: UITextField = {
        let tf = UITextField()
        tf.adjustsFontSizeToFitWidth = true
        tf.textColor = .systemRed
        tf.backgroundColor = .white
        return tf
    }()
    
    lazy var buttonRefresh: UIButton = {
        let button = UIButton()
        button.backgroundColor = .cyan
        button.setTitle("刷新", for: .normal)
        return button
    }()
    lazy var buttonExit: UIButton = {
        let button = UIButton()
        button.backgroundColor = .cyan
        button.setTitle("原生退出", for: .normal)
        return button
    }()
    
    var isShowVoiceView: Bool = false
    
    var isLogin = false
    var isShop = false
    var isPayment = false
}