import OpenIMSDK
import ZLPhotoBrowser
import AVFoundation
import WebKit
import SwiftyJSON
import AliRTCSdk

extension MainWebView: WKScriptMessageHandler {
    
    public func webView(_ webView: WKWebView,
                        didFailProvisionalNavigation navigation: WKNavigation!,
                        withError error: Error) {
        debugPrintS("didFailProvisionalNavigation")
    }
    
    public func webView(_ webView: WKWebView,
                        didFinish navigation: WKNavigation!) {
        debugPrint("webWiew load success")
        if isLogin {
            webView.evaluateJavaScript("window.location.href='index.html#/login'")
        }
        if isShop {
            webView.evaluateJavaScript("window.location.href='index.html#/shop'")
        }
        if isPayment {
            webView.evaluateJavaScript("window.location.href='index.html#/paymentMethod'")
        }
    }
    
    public func webView(_ webView: WKWebView,
                        didFail navigation: WKNavigation!,
                        withError error: Error) {
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
            
            funData = JSON(parseJSON: body["funData"].string ?? "")
            
            let funId = body["funId"].stringValue
            debugPrint("funcname:",funName)
            debugPrint("funcdata", funData)
            debugPrint("funid:", funId)
            
            switch funName {
            case "jumpActivity":
                if funData["activity_name"] == "chat" {
                    MainTabBarController.shared.selectedIndex = 0
                }
                if funData["activity_name"] == "paymentMethod" {
                    MainTabBarController.shared.jumpPayment()
                }
                if funData["activity_name"] == "main" {
                    dismiss(animated: true)
                }
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
                fetchUserInfo(funcId: funId, funcData: funData)
                
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
                fetchAlbumResource(funcId: funId, funcData: funData)
                
            case "goToShoot":
                cameraShoot()
                
            case "createSoundMessage":
                sendVoiceMessage(funcId: funId, funcData: funData)
                
            case "callRTC":
                rtcAction(funcId: funId, funcData: funData)
                
            default:
                break
            }
        }
    }
}


extension MainWebView {
    
    func createJSExecute(_ funcId: String, data: String) {
        let js = "androidApiCallBack('\(funcId)','\(data)')"
        debugPrint(js)
        self.webView.evaluateJavaScript(js)
    }
    
    //发送短信
    func sendSms(_ funcId: String, funcData: JSON) {
        APIService.shared.sendSms(param: funcData.dictionaryObject!) { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let value):
                self.createJSExecute(funcId, data: value.description)
                
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

                kUserToken = json["Token"].stringValue
                kUserLoginModel = json
                let isNew = kUserLoginModel["IsNew"].boolValue.description
                
                OIMManager.manager.login(
                    kUserLoginModel["Id"].stringValue,
                    token: kUserLoginModel["Token"].stringValue
                ) { result in
                    debugPrint("----loginSuccess:", result ?? "")
                
                    let param: Param = ["status": 200,
                                        "msg": "success",
                                        "IsNew": isNew,
                                        "userID": kUserLoginModel["Id"].stringValue,
                                        "imToken": kUserLoginModel["H5Token"].stringValue
                    ]
                    let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
                    self.createJSExecute(funcId, data: str ?? "")
                    NotificationCenter.default.post(name: TTNotifyName.App.OIMSDKLoginSuccess, object: nil)
                    
                    if isNew == "false" {
                        self.dismiss(animated: true)
                    } else {
                        self.webView.evaluateJavaScript("window.location.href='index.html#/setPassword'")
                    }
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
                kUserLoginModel = json
                
                OIMManager.manager.login(
                    kUserLoginModel["Id"].stringValue,
                    token: kUserLoginModel["Token"].stringValue
                ) { result in
                    debugPrint("----loginSuccess:", result ?? "")
                
                    let param: Param = ["status": 200,
                                        "msg": "success",
                                        "userID": kUserLoginModel["Id"].stringValue,
                                        "imToken": kUserLoginModel["H5Token"].stringValue
                    ]
                    let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
                    self.createJSExecute(funcId, data: str ?? "")
                    NotificationCenter.default.post(name: TTNotifyName.App.OIMSDKLoginSuccess, object: nil)
                    
                    self.dismiss(animated: true)
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
            kUserLoginModel = JSON()
            kUserInfoModel = JSON()
            
            let param: Param = ["status": 200,
                                "msg": "success"]
            let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
            self.createJSExecute(funcId, data: str ?? "")
            
        }
    }
    // 扫一扫
    func scan(_ funcId: String) {
        let controller = ScannerVC()
        controller.gk_navigationBar.isHidden = false
        controller.setupScanner(
            "扫一扫",
            .systemGreen,
            .default,
            "将二维码/条码放入框内，即可自动扫描"
        ) { [weak self] code in
            debugPrintS(code)
            guard let `self` = self else { return }
            self.navigationController?.popViewController()
            
            let param: Param = ["data": code]
            let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
            self.createJSExecute(funcId, data: str ?? "")
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    //生成二维码
    func createQRCode(funcId: String, content: String) {
        let image = UIImage.generateQRCode(content, 100, nil, .systemRed)?.pngBase64String()
        let param: Param = ["status": 200, "qr_code": image ?? ""]
        let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
        createJSExecute(funcId, data: str ?? "")
    }
    
    //修改用户信息
    func updateUserInfo(funcId: String, funcData: JSON) {
        APIService.shared.updateUserInfo(param: funcData.dictionaryObject!) { [weak self] result in
            guard let `self` = self else { return }
            debugPrint(result)
            switch result {
            case .success(let model):
                self.createJSExecute(funcId, data: model.toJSONString() ?? "")
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    //获取用户信息
    func fetchUserInfo(funcId: String, funcData: JSON) {
        let data = funcData["data"].stringValue
        var param: Param
        if tt_validateMobile(data) {
            param = ["Phone": data]
        }else {
        param = ["userId": data]
//        let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
//        createJSExecute(funcId, data: str ?? "")
        }
        APIService.shared.fetchUserInfo(param: param) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let model):
                self.createJSExecute(funcId, data: model.toJSONString() ?? "")

            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    //修改密码
    func changePassword(funcId: String, funcData: JSON) {
        var param: Param = ["Phone": kUserLoginModel["Phone"].stringValue]
        param = param + (funcData.dictionaryObject ?? [:])
        APIService.shared.changePasswd(param: param) { [weak self] result in
            guard let `self` = self else { return }
            debugPrint(result)
            switch result {
            case .success(let model):
                self.createJSExecute(funcId, data: model.toJSONString() ?? "")
                
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
            self.createJSExecute(funcId, data: str)
        }
    }
    
    //获取登录信息缓存
    func fetchLoginCache(funcId: String) {
        guard kUserToken.count > 0 else {
            return
        }
        let param: Param = ["status": 200,
                            "msg": "success",
                            "userID": kUserLoginModel["Id"].stringValue,
                            "imToken": kUserLoginModel["H5Token"].stringValue]
        let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
        createJSExecute(funcId, data: str ?? "")
    }
    
    private func sendMessage(_ message: OIMMessageInfo, uid: String, gid: String) {
        let off = OIMOfflinePushInfo()
        off.title = "新消息"
        off.desc = "您有新的消息"
        off.iOSBadgeCount = true
        OIMManager.manager.sendMessage(message, recvID: uid, groupID: gid, offlinePushInfo: off) { message in
            debugPrintS(message)
        } onProgress: { progres in
            debugPrint("progres:\(progres)")
        } onFailure: { code, msg in
            debugPrintS("code:\(code), error:\(msg ?? "")")
        }
    }
    
    ///获取相册获取图片视频
    func fetchAlbumResource(funcId: String, funcData: JSON) {
        let bucket_name = funcData["bucket_name"].stringValue
        let purpose_code = funcData["purpose_code"].intValue
        
        let config = ZLPhotoConfiguration.default()
        config.allowMixSelect = false
        config.allowSelectVideo = true
        config.allowSelectImage = true
        config.maxSelectCount = 1
        let controller = ZLPhotoPreviewSheet()
        controller.selectImageBlock = { [weak self] results, isOrigin in
            guard let `self` = self else { return }
            debugPrint(results, isOrigin)
            if results[0].asset.mediaType == .image {
                ZLPhotoManager.fetchAssetFilePath(asset: results[0].asset) { filePath in
                    guard let filePath = filePath, let fileURL = URL(string: filePath) else { return }
                    if filePath.pathExtension == "HEIC" || filePath.pathExtension == "HEIF" {
                        if let newUrl = tt_convtHEICToJPG(fileURL: fileURL) {
                            self.uploadImage(newUrl, bucketName: bucket_name)
                        }
                    } else if let newUrl = tt_copyFileToTempDir(fileURL: fileURL) {
                        self.uploadImage(newUrl, bucketName: bucket_name)
                    }
                }
            } else if results[0].asset.mediaType == .video {
                ZLPhotoManager.fetchAssetFilePath(asset: results[0].asset) { (filePath) in
                    guard let filePath = filePath, let fileURL = URL(string: filePath) else { return }
                    debugPrint("filePath: \(filePath)")
                    debugPrint(fileURL)
                    debugPrint(fileURL.path)
                    let asset = AVURLAsset(url: fileURL)
                    let time = asset.duration
                    let timeValue = time.value
                    let timeScale = time.timescale
                    let videos = Int(timeValue)/Int(timeScale)
                    debugPrint("videos:\(videos)")
                    
                    if fileURL.pathExtension == "mp4" || fileURL.pathExtension == "MP4" {
                        if let newUrl = tt_copyFileToTempDir(fileURL: fileURL),
                           let snap = tt_fetchVideoSnapshotToTempDir(newUrl) {
                            
//                            let message = OIMMessageInfo.createVideoMessage(
//                                fromFullPath: newUrl.path,
//                                videoType: "mp4",
//                                duration: videos,
//                                snapshotPath: snap.path
//                            )
//                            message.status = .sending
//                            self.sendMessage(message, uid: recv_uid, gid: recv_gid)
                        } else {
                            debugPrint("拷贝文件失败!")
                        }
                    } else { //压缩并转换格式(MOV->mp4) //NOTE: 超大文件会非常耗时，待优化
                        tt_compressVideo(fileURL: fileURL) { newUrl in
                            if let newUrl = newUrl,
                               let snap = tt_fetchVideoSnapshotToTempDir(newUrl) {
                                
//                                let message = OIMMessageInfo.createVideoMessage(
//                                    fromFullPath: newUrl.path,
//                                    videoType: "mp4",
//                                    duration: videos,
//                                    snapshotPath: snap.path
//                                )
//                                message.status = .sending
//                                self.sendMessage(message, uid: recv_uid, gid: recv_gid)
                            } else {
                                debugPrint("导出文件失败!")
                            }
                        }
                    }
                }
            }
        }
        
        controller.showPhotoLibrary(sender: self)
    }
    
    //调用相机
    func cameraShoot() {
        let camera = ZLCustomCamera()
        camera.takeDoneBlock = { [weak self] image, videoUrl in
            debugPrint(image, videoUrl)
        }
        showDetailViewController(camera, sender: nil)
    }
    
    func uploadImage(_ fileURL: URL, bucketName: String) {
        
        APIService.shared.fetchMinio { result in
            switch result {
            case .success(let value):
                if value["status"].intValue == 200 {
                    AWSMinioUploader.shared.upload(
                        param: value["data"],
                        bucketName: bucketName,
                        file: fileURL
                    )
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    //发送语音消息
    func sendVoiceMessage(funcId: String, funcData: JSON) {
        let recv_uid = funcData["recv_uid"].stringValue
        let recv_gid = funcData["recv_gid"].stringValue
        
        if isShowVoiceView {
            self.isShowVoiceView = false
            self.webView.whc_RemoveAttrs(.bottom)
                .whc_Bottom(0)
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }else {
            self.isShowVoiceView = true
            self.webView.whc_RemoveAttrs(.bottom)
                .whc_Bottom(45 + kSafeAreaBottomHeight)
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            self.recordingView.fetchRecordingPermission()
            self.recordingView.sendRecordVoice = { [weak self] url in
                guard let `self` = self else { return }
                let audio = AVURLAsset(url: url)
                let message = OIMMessageInfo.createSoundMessage(fromFullPath: url.path, duration: audio.duration.seconds.int)
                message.status = .sending
                self.sendMessage(message, uid: recv_uid, gid: recv_gid)
            }
        }
    }
    
    /// rtc
    func rtcAction(funcId: String, funcData: JSON) {
        let uuid = UUID()
        let toUserId = funcData["to_user_id"].stringValue
        let toUserName = funcData["to_user_name"].stringValue
        let isAudio = funcData["audio"].boolValue
        let toUserAvatar = funcData["to_user_avatar"].stringValue
        
        func enterChannal(data: JSON, room: String) {
            var userData = data["user_data"].dictionaryObject ?? [:]
            userData["user"] = toUserId
            userData["room"] = room
            userData["call"] = false
            userData["avatar"] = kUserLoginModel["Avatar"].stringValue
            userData["username"] = kUserLoginModel["UserName"].stringValue
            userData["audio"] = isAudio
            userData["oppositeUserId"] = kUserLoginModel["Id"].stringValue
            userData["type"] = "call"
            let str = try? userData.jsonString(using: .utf8, options: .init(rawValue: 0))
            let message = OIMMessageInfo.createCustomMessage(str ?? "", extension: "{}", description: "[通话]")
            let off = OIMOfflinePushInfo()
            off.title = "您收到一个通话"
            off.desc = ""
            off.iOSBadgeCount = true
            OIMManager.manager.sendMessage(message, recvID: toUserId, groupID: "", offlinePushInfo: off) { [weak self] message in
                guard let `self` = self else { return }
                debugPrintS(message)
                
            } onProgress: { progres in
                debugPrint("progres:\(progres)")
            } onFailure: { code, msg in
                debugPrintS("code:\(code), error:\(msg ?? "")")
            }
            
            var thisData = data["this_data"].dictionaryObject ?? [:]
            thisData["user"] = kUserLoginModel["Id"].stringValue
            thisData["room"] = room
            thisData["call"] = true
            thisData["avatar"] = toUserAvatar
            thisData["username"] = toUserName
            thisData["audio"] = isAudio
            thisData["oppositeUserId"] = toUserId
            let str2 = try? userData.jsonString(using: .utf8, options: .init(rawValue: 0))
            let controller = RTCController()
            controller.rtcData = JSON(thisData)
            self.navigationController?.pushViewController(controller)
        }
        
        let param: Param = ["user": toUserId, "room": uuid, "thisUser": kUserLoginModel["Id"].intValue]
        APIService.shared.fetchRTCData(param: param) { [weak self] result in
            guard let `self` = self else { return }
            debugPrint(result)
            switch result {
            case .success(let model):
                debugPrintS(model)
                enterChannal(data: model, room: uuid.uuidString)
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}

extension MainWebView: OIMAdvancedMsgListener {
    public func onRecvNewMessage(_ msg: OIMMessageInfo) {
        guard let custom = msg.customElem, let data = custom.data else { return  }
        let json = JSON(parseJSON: data)
        if json["type"].stringValue == "call" {
            //进入通话页面
            let controller = RTCController()
            controller.rtcData = json
            controller.recvMessage = msg
            navigationController?.pushViewController(controller)
        }else if json["type"].stringValue == "hang_up" {
            //挂断 退出通话页面
            if let con = navigationController?.topViewController, con is RTCController {
                navigationController?.popViewController(animated: true)
            }
        }
    }
}


