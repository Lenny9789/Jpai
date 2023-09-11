
import UIKit
import OpenIMSDK
import AudioToolbox


// -1 链接失败 0 链接中 1 链接成功 2 同步开始 3 同步结束 4 同步错误
public enum ConnectionStatus: Int {
    case connectFailure = 0
    case connecting = 1
    case connected = 2
    case syncStart = 3
    case syncComplete = 4
    case syncFailure = 5
    case kickedOffline = 6
    
    public var title: String {
        switch self {
        case .connectFailure:
            return "连接失败"
        case .connecting:
            return "连接中"
        case .connected:
            return "连接成功"
        case .syncStart:
            return "同步开始"
        case .syncComplete:
            return "同步完成"
        case .syncFailure:
            return "同步失败"
        case .kickedOffline:
            return "账号在其它设备登录"
        }
    }
}
public enum SDKError: Int {
    case blockedByFriend = 600 // 被对方拉黑
    case deletedByFriend = 601 // 被对方删除
    case refuseToAddFriends = 10007 // 该用户已设置不可添加
}

public enum CustomMessageType: Int {
    case call = 901 // 音视频
    case customEmoji = 902 // emoji
    case tagMessage = 903 // 标签消息
    case moments = 904 // 朋友圈
    case meeting = 905 // 会议
    case blockedByFriend = 910 // 被拉黑
    case deletedByFriend = 911 // 被删除
}

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
//        OpenIMSDK.OIMManager.callbacker.addFriendListener(listener: self)
//        OpenIMSDK.OIMManager.callbacker.addGroupListener(listener: self)
        OpenIMSDK.OIMManager.callbacker.addConversationListener(listener: self)
        OpenIMSDK.OIMManager.callbacker.addAdvancedMsgListener(listener: self)
        
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
    private func onNewRecvMessageRevoked(_ messageRevoked: OIMMessageRevokedInfo) {
        msgRevokeReceived.onNext(messageRevoked)
    }
}
