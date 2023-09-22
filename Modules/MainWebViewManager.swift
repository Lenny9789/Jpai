import OpenIMSDK
import ZLPhotoBrowser

extension MainWebView {
    
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
                    self.createJSExecute(funcId, data: str ?? "")
                    
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
                    self.createJSExecute(funcId, data: str ?? "")
                    
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
    func fetchUserInfo(funcId: String) {
        APIService.shared.fetchUserInfo() { [weak self] result in
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
        var param: Param = ["Phone": kUserModel["Phone"].stringValue]
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
                            "userID": kUserModel["Id"].stringValue,
                            "imToken": kUserModel["H5Token"].stringValue]
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
            debugPrintS("code:\(code), error:\(msg)")
        }
    }
    
    ///获取相册获取图片视频
    func fetchAlbumResource(funcId: String, funcData: JSON) {
        let recv_uid = funcData["recv_uid"].stringValue
        let recv_gid = funcData["recv_gid"].stringValue
        
        let config = ZLPhotoConfiguration.default()
        config.allowMixSelect = false
        config.allowSelectVideo = true
        config.allowSelectImage = true
        config.maxSelectCount = 1
        let controller = ZLPhotoPreviewSheet()
        controller.selectImageBlock = { [weak self] images, phAssets, isOrigin in
            guard let `self` = self else { return }
            if phAssets[0].mediaType == .image {
                ZLPhotoManager.fetchAssetFilePath(asset: phAssets[0]) { filePath in
                    guard let filePath = filePath, let fileURL = URL(string: filePath) else { return }
                    
                    if let newUrl = tt_copyFileToTempDir(fileURL: fileURL) {
                        let message = OIMMessageInfo.createImageMessage(fromFullPath: newUrl.path)
                        message.status = .sending
                        self.sendMessage(message, uid: recv_uid, gid: recv_gid)
                    }
                }
            } else if phAssets[0].mediaType == .video {
                ZLPhotoManager.fetchAssetFilePath(asset: phAssets[0]) { (filePath) in
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
                            
                            let message = OIMMessageInfo.createVideoMessage(
                                fromFullPath: newUrl.path,
                                videoType: "mp4",
                                duration: videos,
                                snapshotPath: snap.path
                            )
                            message.status = .sending
                            self.sendMessage(message, uid: recv_uid, gid: recv_gid)
                        } else {
                            debugPrint("拷贝文件失败!")
                        }
                    } else { //压缩并转换格式(MOV->mp4) //NOTE: 超大文件会非常耗时，待优化
                        tt_compressVideo(fileURL: fileURL) { newUrl in
                            if let newUrl = newUrl,
                               let snap = tt_fetchVideoSnapshotToTempDir(newUrl) {
                                
                                let message = OIMMessageInfo.createVideoMessage(
                                    fromFullPath: newUrl.path,
                                    videoType: "mp4",
                                    duration: videos,
                                    snapshotPath: snap.path
                                )
                                message.status = .sending
                                self.sendMessage(message, uid: recv_uid, gid: recv_gid)
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
                .whc_Bottom(45 + kSafeAreaBottomHeight())
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
    
    func createJSExecute(_ funcId: String, data: String) {
        let js = "androidApiCallBack('\(funcId)','\(data)')"
        debugPrint(js)
        self.webView.evaluateJavaScript(js)
    }
}
