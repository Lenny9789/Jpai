import UIKit
import WebKit

//  说明：可根据内容自适应高度的webview，支持图片点击响应
//  图片和文字失调解决方案参考：http://www.bubuko.com/infodetail-1340116.html
//
open class TTFlexibleWebView: WKWebView {
    
    public var webHeightChangedBlock: ( (CGFloat) -> () )?
    public var imageItemClickedBlock: ( (Array<String>, Int) -> () )?

    public var heightOffset: CGFloat = 0;
    
    private var urlArr = [String]()
    private var lastHeight: CGFloat?
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        
        self.uiDelegate = self
        self.navigationDelegate = self

        self.scrollView.bounces = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isScrollEnabled = false
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addHeightChangedObserver() {
        scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    public func removeHeightChangedObserver() {
        scrollView.removeObserver(self, forKeyPath: "contentSize", context: nil)
    }
    
    public func loadHTMLString(_ string: String) {
        //禁用WebView中双击和手势缩放页面脚本代码
        let disableGestureCode = "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\" />"
        
        //iOS中用WebView的loadHTMLString后图片和文字失调解决方法:
        //用一个for循环，拿到所有的图片，对每个图片都处理一次，让图片的宽为100%，就是按照屏幕宽度自适应；让图片的高atuo，自动适应。文字的字体大小，可以去改font-size:14px，这里我用的是14px。
//        var htmls = """
//                    "<html> \n"
//                    "<head> \n"
//                    "<style type=\"text/css\"> \n"
//                    "body {}\n"
//                    "</style> \n"
//                    "</head> \n"
//                    "<body>"
//                    "<script type='text/javascript'>"
//                    "window.onload = function(){\n"
//                        "var $img = document.getElementsByTagName('img');\n"
//                        "for(var p in  $img){\n"
//                            " $img[p].style.width = '100%%';\n"
//                            "$img[p].style.height = 'auto'\n"
//                        "}\n"
//                    "}"
//                    "</script>\(string)\n\(disableGestureCode)"
//                    "</body>"
//                    "</html>"
//                    """
        
        let htmls = "<html> \n<head> \n<style type=\"text/css\"> \nbody {}\n</style> \n</head> \n<body><script type='text/javascript'>window.onload = function(){\nvar $img = document.getElementsByTagName('img');\nfor(var p in  $img){\n $img[p].style.width = '100%%';\n$img[p].style.height = 'auto'\n}\n}</script>\(string)\n\(disableGestureCode)</body></html>"
        
        self.loadHTMLString(htmls, baseURL: nil)
    }
    
    public func loadHTMLStringWithoutHandleImage(_ string: String) {
        //禁用WebView中双击和手势缩放页面脚本代码
        let disableGestureCode = "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\" />"
        
        let htmls = """
                    "<html> \n"
                    "<head> \n"
                    "<style type=\"text/css\"> \n"
                    "body {}\n"
                    "</style> \n"
                    "</head> \n"
                    "<body>"
                    "<script type='text/javascript'>"
                    "window.onload = function(){\n"
                    "}"
                    "</script>\(string)\n\(disableGestureCode)"
                    "</body>"
                    "</html>"
                    """
        
        self.loadHTMLString(htmls, baseURL: nil)
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        switch keyPath {
        case "contentSize":
            let jScript = "document.body.offsetHeight"
            self.evaluateJavaScript(jScript) { [weak self] (obj, error) in
                guard let `self` = self else { return }
                var webHeight: CGFloat = 0
                if obj is String {
                    webHeight = (obj as! String).toCGFloat()
                } else if obj is NSNumber {
                    webHeight = CGFloat((obj as! NSNumber).floatValue)
                }
                
                if webHeight != self.lastHeight {
                    debugPrint("webHeight:%f", webHeight);

                    var newFrame = self.frame
                    newFrame.size.height = webHeight + self.heightOffset
                    self.frame = newFrame;
                    
                    self.webHeightChangedBlock?(webHeight+self.heightOffset)
                    
                    self.lastHeight = webHeight
                }
            }
            
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            break
        }
    }
}

extension TTFlexibleWebView: WKUIDelegate, WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        //这里是js，主要目的实现对url的获取
        let jsGetImages = """
                         "function getImages(){\
                            var objs = document.getElementsByTagName(\"img\");\
                            var imgScr = '';\
                            for(var i=0;i<objs.length;i++){\
                                imgScr = imgScr + objs[i].src + '+';\
                            };\
                            return imgScr;\
                         };"
                         """
        
        self.evaluateJavaScript(jsGetImages) { [weak self] (obj, error) in
            guard let `self` = self else { return }

            self.evaluateJavaScript("getImages()") { [weak self] (obj, error) in
                guard let `self` = self else { return }
                
                if let obj = obj, obj is String {
                    self.urlArr = (obj as! String).components(separatedBy: "+")
                    if self.urlArr.count >= 2 {
                        self.urlArr.removeLast()
                    }
                    debugPrint("urlArr: \(self.urlArr)")
                    
                    //添加图片可点击js
                    let jsImageClickEnable = """
                                            "function registerImageClickAction(){\
                                                var imgs=document.getElementsByTagName('img');\
                                                var length=imgs.length;\
                                                for(var i=0;i<length;i++){\
                                                    img=imgs[i];\
                                                    img.onclick=function(){\
                                                    window.location.href='image-preview:'+this.src}\
                                                }\
                                            }";
                                            """
                    
                    self.evaluateJavaScript(jsImageClickEnable) { [weak self] (obj, error) in
                        guard let `self` = self else { return }
                        
                        self.evaluateJavaScript("registerImageClickAction();") { (obj, error) in
                        }
                    }
                }
            }
        }
        //字体颜色
        self.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#FFFFFF'", completionHandler: nil)
        
        // 通过强制设置页面的宽度为我们当前的webView的宽度。解决偶尔出现的高度持续增加的Bug
        self.evaluateJavaScript("document.getElementsByName(\"viewport\")[0].content = \"width=self.webView.frame.size.width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", completionHandler: nil)

        // 防止内存飙升
        UserDefaults.standard.set(0, forKey: "WebKitCacheModelPreferenceKey")
        UserDefaults.standard.set(false, forKey: "WebKitDiskImageCacheEnabled")
        UserDefaults.standard.set(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        UserDefaults.standard.synchronize()
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let absoluteString = navigationAction.request.url?.absoluteString
        if let absoluteString = absoluteString,
           let scheme = navigationAction.request.url?.scheme, scheme == "image-preview" {
            let keyStr = "image-preview:"
            //path 就是被点击图片的url
            let keyIndex = absoluteString.index(keyStr.startIndex, offsetBy: keyStr.count)
            var path = String(absoluteString.suffix(from: keyIndex))
            
            var charSet = CharacterSet.urlQueryAllowed
            charSet.insert(charactersIn: "#") //转码处理忽略`#`
            path = path.addingPercentEncoding(withAllowedCharacters: charSet) ?? ""
            debugPrint("clicked path: %@", path);

            if path.count > 0, urlArr.count > 0 {
                let index = urlArr.firstIndex(of: path)
                if let index = index, index >= 0, index < urlArr.count {
                    imageItemClickedBlock?(urlArr, index)
                }
            }
            
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
}
