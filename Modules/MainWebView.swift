import UIKit
import WebKit
#if canImport(SwiftTheme)
import SwiftTheme
#endif

import OpenIMSDK
import ZLPhotoBrowser

open class MainWebView: TTViewController, WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate {
    
    private var url: String!
    private var navTitle: String?
    private var isload: Bool = false
    private let disposebag = DisposeBag()
    
    lazy var config: WKWebViewConfiguration = {
        let user = WKUserContentController()
        
//        user.add(self, name: "onSubmit_Code") //登录
//        user.add(self, name: "sendCode")  //登录获取验证码
//        user.add(self, name: "onSubmit")  //注册获取验证码
        user.add(self, name: "send2iOSApi")
//        user.add(self, name: "androidApi")
        let conf = WKWebViewConfiguration()
        conf.userContentController = user
        return conf
    }()
    
    lazy var webView: WKWebView = {
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
//        gk_navigationBar.isHidden = true
//        gk_statusBarHidden = true
        
        view.addSubview(webView)
        view.addSubview(progressView)
        webView.whc_AutoSize(left: 0, top: kStatusAndNavBarHeight, right: 0, bottom: 0)
        progressView.whc_Top(kStatusAndNavBarHeight)
            .whc_Left(0)
            .whc_Right(0)
            .whc_Height(2)
        
        webView.addSubview(button)
        button.size = CGSize(width: 100, height: 44)
        gk_navRightBarButtonItem = UIBarButtonItem(customView: button)
        
        button.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
            self.webView.reload()
        }.disposed(by: disposebag)
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
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .cyan
        button.setTitle("刷新", for: .normal)
        return button
    }()
}

import SwiftyJSON
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
        
        if let body = JSON(rawValue: message.body) {
            let funName = body["funName"].stringValue
            var funData: JSON!
            if body["funData"] != nil {
                funData = JSON(parseJSON: body["funData"].string ?? "")
            }
            
            let funId = body["funId"].stringValue
            debugPrint(funName)
            debugPrint(funData)
            debugPrint(funId)
            
            switch funName {
            case "sendSms":
                sendSms(funId, funcData: funData)
                
            case "loginOrRegister":
                loginPhone(funId, funcData: &funData)
                
            case "loginByPassword":
                loginPasswd(funId, funcData: &funData)
                
            case "loginOut":
                loginOut(funId)
                
            case "scan":
                scan(funId)
                
            case "getQrCode":
                let shareContent = funData["share_content"].string ?? ""
                createQRCode(funcId: funId, content: shareContent)
                
            case "userUpdateInfo":
                updateUserInfo(funcId: funId, funcData: funData)
                
            case "getUserInfo":
                fetchUserInfo(funcId: funId)
                
            case "changeUserPassword":
                changePassword(funcId: funId, funcData: funData)
                
            case "getVideoSnapOrPictureToBase64":
                break
            case "getHistoryMessage":
                let conversationID = body["funData"].stringValue
                fetchConversationMessage(funcId: funId, conversationId: conversationID)
                
            case "getLoginCertificate":
                fetchLoginCache(funcId: funId)
                
            case "getAlbumResource":
                fetchAlbumResource(funcId: funId)
                
            case "goToShoot":
                break
            default:
                break
            }
        }
    }
}

extension MainWebView {
    
    //发送短信
    func sendSms(_ funcId: String, funcData: JSON) {
        APIService.shared.sendSms(param: funcData.dictionaryObject!) { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let value):
                
                let js = self.createJS(funcId, data: value.description)
                self.webView.evaluateJavaScript(js)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    //手机号登录注册
    func loginPhone(_ funcId: String, funcData: inout JSON) {
        funcData["PlatformId"] = 1
        APIService.shared.loginRegister(param: funcData.dictionaryObject!) { [weak self] result in
            guard let `self` = self else { return }
            debugPrint(result)
            switch result {
            case .success(let model):
                let json = JSON(model["data"])
                if json.rawValue is String {
                    //                            let js = "androidApiCallBack('\(funId)','\(model.description)')"
                    //                            self.webView.evaluateJavaScript(js)
                    return
                }
                kUserToken = json["H5Token"].stringValue
                kUserModel = json
                
                OIMManager.manager.login(kUserModel["Id"].stringValue, token: kUserModel["Token"].stringValue) { result in
                    debugPrint("----loginSuccess:", result ?? "")
                    let param: Param = ["status": 200,
                                        "msg": "success",
                                        "userID": kUserModel["Id"].stringValue,
                                        "imToken": kUserModel["H5Token"].stringValue]
                    let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
                    let js = self.createJS(funcId, data: str ?? "")
                    self.webView.evaluateJavaScript(js)
                } onFailure: { code, message in
                    debugPrint("---------code:\(code), message: \(message ?? "")")
                }
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
            
        }
    }
    //密码登录
    func loginPasswd(_ funcId: String, funcData: inout JSON) {
        funcData["PlatformId"] = 1
        APIService.shared.loginPasswd(param: funcData.dictionaryObject!) { [weak self] result in
            guard let `self` = self else { return }
            debugPrint(result)
            switch result {
            case .success(let model):
                let json = JSON(model["data"])
                kUserToken = json["H5Token"].stringValue
                kUserModel = json
                
                OIMManager.manager.login(kUserModel["Id"].stringValue, token: kUserModel["Token"].stringValue) { result in
                    debugPrint("----loginSuccess:", result ?? "")
                    let param: Param = ["status": 200,
                                        "msg": "success",
                                        "userID": kUserModel["Id"].stringValue,
                                        "imToken": kUserModel["H5Token"].stringValue]
                    let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
                    let js = self.createJS(funcId, data: str ?? "")
                    debugPrint(js)
                    self.webView.evaluateJavaScript(js)
                } onFailure: { code, message in
                    debugPrint("---------code:\(code), message: \(message ?? "")")
                }
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    //退出登录
    func loginOut(_ funcId: String) {
        OIMManager.manager.logoutWith { message in
            debugPrint(message)
            
            kUserToken = ""
            kUserModel = JSON()
            kUserInfoModel = JSON()
            
            let param: Param = ["status": 200,
                                "msg": "success"]
            let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
            let js = self.createJS(funcId, data: str ?? "")
            self.webView.evaluateJavaScript(js)
        }
    }
    // 扫一扫
    func scan(_ funcId: String) {
        let controller = ScannerVC()
        controller.gk_navigationBar.isHidden = false
        controller.setupScanner("扫一扫", .systemGreen, .default, "将二维码/条码放入框内，即可自动扫描") { code in
            
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
        //                self.present(controller, animated: true)
        
    }
    //生成二维码
    func createQRCode(funcId: String, content: String) {
        let image = UIImage.generateQRCode(content, 100, nil, .systemRed)?.pngBase64String()
        let param: Param = ["status": 200, "qr_code": image ?? ""]
        let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
        let js = createJS(funcId, data: str ?? "")
        
        self.webView.evaluateJavaScript(js)
    }
    
    //修改用户信息
    func updateUserInfo(funcId: String, funcData: JSON) {
        APIService.shared.updateUserInfo(param: funcData.dictionaryObject!) { [weak self] result in
            guard let `self` = self else { return }
            debugPrint(result)
            switch result {
            case .success(let model):
                let js = self.createJS(funcId, data: model.toJSONString() ?? "")
                self.webView.evaluateJavaScript(js)
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    //获取用户信息
    func fetchUserInfo(funcId: String) {
        APIService.shared.fetchUserInfo() { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let model):
                
                let js = self.createJS(funcId, data: model.toJSONString() ?? "")
                self.webView.evaluateJavaScript(js)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    //修改密码
    func changePassword(funcId: String, funcData: JSON) {
        var param: Param = ["Phone": kUserModel["Phone"].stringValue]
        param = param + (funcData.dictionaryObject ?? [:])
        APIService.shared.changePasswd(param: param) { [weak self] result in
            guard let `self` = self else { return }
            debugPrint(result)
            switch result {
            case .success(let model):
                
                let js = self.createJS(funcId, data: model.toJSONString() ?? "")
                self.webView.evaluateJavaScript(js)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    //获取会话聊天记录
    func fetchConversationMessage(funcId: String, conversationId: String) {
        let param = OIMGetAdvancedHistoryMessageListParam()
        param.conversationID = conversationId
        param.count = 10
        param.startClientMsgID = nil
        OIMManager.manager.getAdvancedHistoryMessageList(param) { listInfo in
            guard let list = listInfo else { return }
            
            let str = list.mj_JSONString().replacingOccurrences(of: "\\", with: "\\\\")
            
            let js = self.createJS(funcId, data: str)
            self.webView.evaluateJavaScript(js)
        }
    }
    
    //获取登录信息缓存
    func fetchLoginCache(funcId: String) {
        guard kUserToken.count > 0 else {
            return
        }
        let param: Param = ["status": 200,
                            "msg": "success",
                            "userID": kUserModel["Id"].stringValue,
                            "imToken": kUserModel["H5Token"].stringValue]
        let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
        let js = createJS(funcId, data: str ?? "")
        self.webView.evaluateJavaScript(js)
    }
    
    ///获取相册获取图片视频
    func fetchAlbumResource(funcId: String) {
        let config = ZLPhotoConfiguration.default()
        config.allowMixSelect = false
        config.allowSelectVideo = false
        config.allowSelectImage = true
        let controller = ZLPhotoPreviewSheet()
        controller.selectImageBlock = { images, phAssets, isOrigin in
            
        }
        controller.showPhotoLibrary(sender: self)
    }
    
    func createJS(_ funcId: String, data: String) -> String {
        let js = "androidApiCallBack('\(funcId)','\(data)')"
        debugPrint(js)
        return js
    }
}

