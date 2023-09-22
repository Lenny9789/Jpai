
import UIKit
import OpenIMSDK
import AudioToolbox



class MessageManager: NSObject {
    public static let addFriendPrefix = "io.openim.app/addFriend/"
    public static let joinGroupPrefix = "io.openim.app/joinGroup/"
    public static let shared = MessageManager()
    
    private(set) var imManager: OpenIMSDK.OIMManager!
    /// 好友申请列表新增
    public let friendApplicationChangedSubject: PublishSubject<OIMFriendApplication> = .init()
    /// 组申请信息更新
    public let groupApplicationChangedSubject: PublishSubject<OIMGroupApplicationInfo> = .init()
    public let groupInfoChangedSubject: PublishSubject<OIMGroupInfo> = .init()
    public let contactUnreadSubject: PublishSubject<Int> = .init()
    
    public let conversationChangedSubject: BehaviorSubject<[OIMConversationInfo]> = .init(value: [])
    public let friendInfoChangedSubject: BehaviorSubject<OIMFriendInfo?> = .init(value: nil)
    
    public let onBlackAddedSubject: BehaviorSubject<OIMBlackInfo?> = .init(value: nil)
    public let onBlackDeletedSubject: BehaviorSubject<OIMBlackInfo?> = .init(value: nil)
    
    public let newConversationSubject: BehaviorSubject<[OIMConversationInfo]> = .init(value: [])
    public let totalUnreadSubject: BehaviorSubject<Int> = .init(value: 0)
    public let newMsgReceivedSubject: PublishSubject<OIMMessageInfo> = .init()
    public let c2cReadReceiptReceived: BehaviorSubject<[OIMReceiptInfo]> = .init(value: [])
    public let groupReadReceiptReceived: BehaviorSubject<[OIMReceiptInfo]> = .init(value: [])
    public let groupMemberInfoChange: BehaviorSubject<OIMGroupMemberInfo?> = .init(value: nil)
    public let joinedGroupAdded: BehaviorSubject<OIMGroupInfo?> = .init(value: nil)
    public let joinedGroupDeleted: BehaviorSubject<OIMGroupInfo?> = .init(value: nil)
    public let msgRevokeReceived: PublishSubject<OIMMessageRevokedInfo> = .init()
    public let currentUserRelay: BehaviorRelay<OIMUserInfo?> = .init(value: nil)
    public let momentsReceivedSubject: PublishSubject<String?> = .init()
//    public let meetingStreamChange: PublishSubject<MeetingStreamEvent> = .init()
//    public let organizationUpdated: PublishSubject<String?> = .init()
    public let didSendMessageSuccess: PublishSubject<Void> = .init()
    /// 连接状态
    public let connectionRelay: BehaviorRelay<ConnectionStatus> = .init(value: .connecting)
    
    public var userId: String = ""
    // 查询在线状态等使用
    public var sdkAPIAdrr = ""
    // 业务层查询组织架构等使用
    public var businessServer = ""
    public var businessToken: String?
    // 上次响铃时间
    private var remindTimeStamp: Double = NSDate().timeIntervalSince1970
    // 开启响铃
    public var enableRing = true
    // 开启震动
    public var enableVibration = true
    
    // 设置业务服务器的参数
    public func setup(businessServer: String, businessToken: String?) {
        self.businessServer = businessServer
        self.businessToken = businessToken
    }
    
    func setupMessageManager() -> Bool {
        IMController.shared.imManager = OIMManager.manager
        var config = OIMInitConfig()
        config.apiAddr = kApiAddress
        config.wsAddr = kWsAddress
        config.objectStorage = "minio"
        config.isLogStandardOutput = false
        
        let result = OIMManager.manager.initSDK(with: config) { [weak self] in
            self?.connectionRelay.accept(.connecting)
        } onConnectFailure: { [weak self] code, msg in
            print("onConnectFailed code:\(code), msg:\(String(describing: msg))")
            self?.connectionRelay.accept(.connectFailure)
        } onConnectSuccess: {[weak self] in
            print("onConnectSuccess")
            self?.connectionRelay.accept(.connected)
        } onKickedOffline: {[weak self] in
            print("onKickedOffline")
//            onKickedOffline?()
            self?.connectionRelay.accept(.kickedOffline)
        } onUserTokenExpired: {
            print("onUserTokenExpired")
        }
        
        // Set listener
        OIMManager.callbacker.addFriendListener(listener: self)
        OIMManager.callbacker.addGroupListener(listener: self)
        OIMManager.callbacker.addConversationListener(listener: self)
        OIMManager.callbacker.addAdvancedMsgListener(listener: self)
        
        
        
        return result
    }
    
    // 正在聊天的会话不响铃
    public var chatingConversationID: String = ""
    
    // 响铃或者震动
    func ringAndVibrate() {
        if NSDate().timeIntervalSince1970 - remindTimeStamp >= 1 { // 响铃间隔1秒钟
            // 如果当前会话有
            // 新消息铃声
            if enableRing {
                var theSoundID : SystemSoundID = 0
                let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/sms-received1.caf")
                let err = AudioServicesCreateSystemSoundID(url as CFURL, &theSoundID)
                
                if err == kAudioServicesNoError {
                    AudioServicesPlaySystemSoundWithCompletion(theSoundID, {
                        AudioServicesDisposeSystemSoundID(theSoundID)
                    })
                }
            }
            // 新消息震动
            if enableVibration {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            }
            remindTimeStamp = NSDate().timeIntervalSince1970
        }
    }
    
    func sendCustomMessage(param: Param, recvID: String) {
        let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
        let message = OIMMessageInfo.createCustomMessage(str ?? "", extension: "[通话]", description: "")
        let off = OIMOfflinePushInfo()
        off.title = "您收到一个通话"
        off.desc = ""
        off.iOSBadgeCount = true
        OIMManager.manager.sendMessage(message, recvID: recvID, groupID: "", offlinePushInfo: off) { [weak self] message in
            guard let `self` = self else { return }
            debugPrintS(message)
            self.didSendMessageSuccess.onNext(())
        } onProgress: { progres in
            debugPrint("progres:\(progres)")
        } onFailure: { code, msg in
            debugPrintS("code:\(code), error:\(msg ?? "")")
        }
    }
    
    func getConversation(sessionType: ConversationType = .undefine,
                         sourceId: String = "",
                         conversationID: String = "",
                         onSuccess: @escaping (OIMConversationInfo) -> Void) {
        
        if !conversationID.isEmpty {
            
//            Self.shared.imManager.getMultipleConversation([conversationID]) { conversations in
//                onSuccess(conversations?.first?.toConversationInfo())
//            } onFailure: { code, msg in
//                print("创建会话失败:\(code), .msg:\(msg)")
//            }
            OIMManager.manager.getMultipleConversation([conversationID]) { [weak self] info in
//                guard let `self` = self else { return }
                guard let info = info, info.count > 0 else { return }
                onSuccess(info[0])
            } onFailure: { code, error in
                print("创建会话失败:\(code), .msg:\(error)")
            }
        } else {
            
            let conversationType = OIMConversationType(rawValue: sessionType.rawValue) ?? OIMConversationType.undefine
            
//            Self.shared.imManager.getOneConversation(withSessionType: conversationType, sourceID: sourceId) { (conversation: OIMConversationInfo?) in
//                onSuccess(conversation?.toConversationInfo())
//            } onFailure: { code, msg in
//                print("创建会话失败:\(code), .msg:\(msg)")
//            }
            
            OIMManager.manager.getOneConversation(
                withSessionType: conversationType,
                sourceID: sourceId
            ) { [weak self] conversation in
//                guard let `self` = self else { return }
                guard let conversation = conversation else { return }
                onSuccess(conversation)
            }
        }
    }
}

extension MessageManager: OIMConversationListener {
    
    func onConversationChanged(_ conversations: [OIMConversationInfo]) {
        
        conversationChangedSubject.onNext(conversations)
    }
    public func onSyncServerStart() {
        connectionRelay.accept(.syncStart)
    }
    
    public func onSyncServerFinish() {
        connectionRelay.accept(.syncComplete)
    }
    
    public func onSyncServerFailed() {
        connectionRelay.accept(.syncFailure)
    }
    
    public func onNewConversation(_ conversations: [OIMConversationInfo]) {
        
        let arr = conversations.compactMap { $0 }
        newConversationSubject.onNext(arr)
    }
    
    public func onTotalUnreadMessageCountChanged(_ totalUnreadCount: Int) {
        totalUnreadSubject.onNext(totalUnreadCount)
    }
}

extension MessageManager: OIMAdvancedMsgListener {
    
    func onRecvNewMessage(_ msg: OIMMessageInfo) {
        if msg.contentType.rawValue < 1000,
           msg.contentType != .typing,
           msg.contentType != .revoke,
           msg.contentType != .hasReadReceipt,
           msg.contentType != .groupHasReadReceipt {
            OIMManager.manager.getOneConversation(withSessionType: msg.sessionType,
                                                     sourceID: msg.sessionType == .C2C ? msg.sendID! : msg.groupID!,
                                                     onSuccess: { conversation in
                
                if conversation!.conversationID != self.chatingConversationID,
                   conversation!.unreadCount > 0,
                   conversation!.recvMsgOpt == .receive {
                    
                    self.ringAndVibrate()
                }
            })
        }
        newMsgReceivedSubject.onNext(msg)
    }
    
    func onRecvC2CReadReceipt(_ receiptList: [OIMReceiptInfo]) {
        c2cReadReceiptReceived.onNext(receiptList.compactMap { $0 })
    }
    
    func onRecvGroupReadReceipt(_ groupMsgReceiptList: [OIMReceiptInfo]) {
        groupReadReceiptReceived.onNext(groupMsgReceiptList.compactMap { $0 })
    }
    
    // 启用新的撤回操作
    internal func onNewRecvMessageRevoked(_ messageRevoked: OIMMessageRevokedInfo) {
        msgRevokeReceived.onNext(messageRevoked)
    }
}
extension MessageManager: OIMFriendshipListener {
    @objc public func onFriendApplicationAdded(_ application: OIMFriendApplication) {
        friendApplicationChangedSubject.onNext(application)
    }
    
    @objc public func onFriendInfoChanged(_ info: OIMFriendInfo) {
        friendInfoChangedSubject.onNext(info)
    }
    
    public func onBlackAdded(_ info: OIMBlackInfo) {
        onBlackAddedSubject.onNext(info)
    }
    
    public func onBlackDeleted(_ info: OIMBlackInfo) {
        onBlackDeletedSubject.onNext(info)
    }
}
// MARK: OIMGroupListener

extension MessageManager: OIMGroupListener {
    public func onGroupApplicationAdded(_ groupApplication: OIMGroupApplicationInfo) {
        groupApplicationChangedSubject.onNext(groupApplication)
    }
    
    public func onGroupInfoChanged(_ changeInfo: OIMGroupInfo) {
        groupInfoChangedSubject.onNext(changeInfo)
    }
    
    public func onGroupMemberInfoChanged(_ changeInfo: OIMGroupMemberInfo) {
        groupMemberInfoChange.onNext(changeInfo)
    }
    
    public func onJoinedGroupAdded(_ groupInfo: OIMGroupInfo) {
        joinedGroupAdded.onNext(groupInfo)
    }
    
    public func onJoinedGroupDeleted(_ groupInfo: OIMGroupInfo) {
        joinedGroupDeleted.onNext(groupInfo)
    }
}
