import Photos
import ZLPhotoBrowser


class ChatViewModel: BaseViewModel {
    
    init(apiService: APIService = .shared) {
        super.init()
        self.apiService = apiService
        setupAlertDelegator(with: self)
    }
    
    var conversation: OIMConversationInfo!
    
    private var lastMinSeq: Int!
    private var listIsEnd: Bool = false
    private var startClientMsgID: String = ""
    var messages: [OIMMessageInfo] = []
    
    func fetchMessages(completion: @escaping (Bool) -> Void) {
        let param = OIMGetAdvancedHistoryMessageListParam()
        param.conversationID = conversation.conversationID
        param.count = 20
        param.startClientMsgID = nil
        
        OIMManager.manager.getAdvancedHistoryMessageList(param) { [weak self] info in
            guard let `self` = self else { return }
            guard let info = info, info.errCode == 0 else {
                completion(false)
                return
            }
            self.cellHeightCache.removeAll()
            self.messages = info.messageList
            self.lastMinSeq = info.lastMinSeq
            self.listIsEnd = info.isEnd
            self.startClientMsgID = info.messageList[0].clientMsgID ?? ""
            completion(true)
            self.makeConversationMessageReaded()
        }
    }
    
    var cellHeightCache = [String: CGFloat]()
    
    func fetchMoreList(completion: @escaping (Bool) -> Void) {
        guard !listIsEnd else {
            completion(false)
            return
        }
        let param = OIMGetAdvancedHistoryMessageListParam()
        param.conversationID = conversation.conversationID
        param.count = 20
        param.lastMinSeq = self.lastMinSeq
        param.startClientMsgID = self.startClientMsgID
        
        OIMManager.manager.getAdvancedHistoryMessageList(param) { [weak self] info in
            guard let `self` = self else { return }
            guard let info = info, info.errCode == 0 else {
                completion(false)
                return
            }
            self.cellHeightCache.removeAll()
            self.messages.insert(contentsOf: info.messageList, at: 0)
            self.lastMinSeq = info.lastMinSeq
            self.listIsEnd = info.isEnd
            completion(true)
        }
    }
    
    func makeConversationMessageReaded() {
        OIMManager.manager.markConversationMessage(
            asRead: conversation.conversationID ?? ""
        ) { result in
            debugPrintS("\(#function)::\(result ?? "")")
        }
    }
    
    func sendTextMessage(_ text: String, completion: @escaping (Bool) -> Void) {
        let message = OIMMessageInfo.createTextMessage(text)
        
        let off = OIMOfflinePushInfo()
        off.title = "新消息"
        off.desc = "您有新的消息"
        off.iOSBadgeCount = true
        OIMManager.manager.sendMessage(
            message,
            recvID: conversation.userID,
            groupID: conversation.groupID,
            offlinePushInfo: off
        ) { [weak self] message in
            guard let `self` = self else { return }
            debugPrintS(message)
            self.messages.append(message!)
            completion(true)
        } onProgress: { progres in
            debugPrint("progres:\(progres)")
        } onFailure: { code, msg in
            debugPrintS("code:\(code), error:\(msg ?? "")")
        }
    }
    
    func sendVoice(_ url: URL, completion: @escaping (Bool) -> Void) {
        let audio = AVURLAsset(url: url)
        let message = OIMMessageInfo.createSoundMessage(fromFullPath: url.path, duration: audio.duration.seconds.int)
        message.status = .sending
        
        let off = OIMOfflinePushInfo()
        off.title = "新消息"
        off.desc = "您有新的消息"
        off.iOSBadgeCount = true
        
        OIMManager.manager.sendMessage(
            message,
            recvID: conversation.userID,
            groupID: conversation.groupID,
            offlinePushInfo: off
        ) { [weak self] message in
            guard let `self` = self else { return }
            debugPrintS(message)
            self.messages.append(message!)
            completion(true)
        } onProgress: { progres in
            debugPrint("progres:\(progres)")
        } onFailure: { code, msg in
            debugPrintS("code:\(code), error:\(msg ?? "")")
        }
    }
    
    func sendMedia(_ media: PHAsset, completion: @escaping (Bool) -> Void) {
        
        func sendMessage(_ message: OIMMessageInfo, offline: OIMOfflinePushInfo) {
            OIMManager.manager.sendMessage(
                message,
                recvID: self.conversation.userID,
                groupID: self.conversation.groupID,
                offlinePushInfo: offline
            ) { [weak self] message in
                guard let `self` = self else { return }
                debugPrintS(message)
                self.messages.append(message!)
                completion(true)
            } onProgress: { progres in
                debugPrint("progres:\(progres)")
            } onFailure: { code, msg in
                completion(false)
                debugPrintS("code:\(code), error:\(msg ?? "")")
            }
        }
        
        if media.mediaType == .image {
            ZLPhotoManager.fetchAssetFilePath(asset: media) { [weak self] filePath in
                guard let `self` = self else { return }
                guard let filePath = filePath, let fileURL = URL(string: filePath) else { return }
               
                if filePath.pathExtension == "HEIC" || filePath.pathExtension == "HEIF" {
                    if let newUrl = tt_convtHEICToJPG(fileURL: fileURL) {
                        let message = OIMMessageInfo.createImageMessage(fromFullPath: newUrl.path)
                        message.status = .sending
                        
                        let off = OIMOfflinePushInfo()
                        off.title = "新消息"
                        off.desc = "[图片]"
                        off.iOSBadgeCount = true
                        sendMessage(message, offline: off)
                    }
                } else if let newUrl = tt_copyFileToTempDir(fileURL: fileURL) {
                    let message = OIMMessageInfo.createImageMessage(fromFullPath: newUrl.path)
                    message.status = .sending
                    
                    let off = OIMOfflinePushInfo()
                    off.title = "新消息"
                    off.desc = "[图片]"
                    off.iOSBadgeCount = true
                    sendMessage(message, offline: off)
                }
            }
        } else if media.mediaType == .video {
            ZLPhotoManager.fetchAssetFilePath(asset: media) { (filePath) in
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
                        
                        let off = OIMOfflinePushInfo()
                        off.title = "新消息"
                        off.desc = "[图片]"
                        off.iOSBadgeCount = true
                        
                        sendMessage(message, offline: off)
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
                            
                            let off = OIMOfflinePushInfo()
                            off.title = "新消息"
                            off.desc = "[图片]"
                            off.iOSBadgeCount = true
                            
                            sendMessage(message, offline: off)
                        } else {
                            debugPrint("导出文件失败!")
                        }
                    }
                }
            }
        }
    }
    
    func fetchUserStatus(completion: @escaping (Bool) -> Void) {
        
        
    }
}
