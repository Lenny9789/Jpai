import Foundation


/// 实现协议，每个接口，都是一个`APIItem`
public struct APIItem: TTAPIProtocol {
    public var url: String { kAppDomain + URLPath }  //域名 + path
    public let description: String
    public let extra: String?
    public var method: TTHTTPMethod
    public var generalHeaders: [String: String]? //header通用参数

    private let URLPath: String  // URL的path

    init(_ path: String, d: String, e: String? = nil, m: TTHTTPMethod = .get) {
        URLPath = path
        description = d
        extra = e
        method = m
        generalHeaders = ["platform": "iOS",
                          "osversion": kSysVersion,
                          "version": "0.1",
                          "model": UIDevice.current.model,
                          "udid": tt_uniqueIdentifier
        ]
    }

    init(_ path: String, m: TTHTTPMethod) {
        self.init(path, d: "", e: nil, m: m)
    }
}

public struct APIRTCItem: TTAPIProtocol {
    public var url: String { kRTCDomain + URLPath }  //域名 + path
    public let description: String
    public let extra: String?
    public var method: TTHTTPMethod
    public var generalHeaders: [String: String]? //header通用参数
    
    private let URLPath: String  // URL的path
    
    init(_ path: String, d: String, e: String? = nil, m: TTHTTPMethod = .get) {
        URLPath = path
        description = d
        extra = e
        method = m
        generalHeaders = ["platform": "iOS",
                          "osversion": kSysVersion,
                          "version": "0.1",
                          "model": UIDevice.current.model,
                          "udid": tt_uniqueIdentifier
        ]
    }
    
    init(_ path: String, m: TTHTTPMethod) {
        self.init(path, d: "", e: nil, m: m)
    }
}



/// 分页信息
public struct APIPage {
    /// 分页页码
    enum Key: String {
        case pageNo     = "pageNo"
        case pageSize   = "pageSize"
    }
    
    /// 分页默认值
    enum DefValue: Int {
        case pageNo     = 1   //默认从1开始
        case pageSize   = 20  //默认20
    }
}

/// API接口地址
public struct API {
    
    // MARK: 登录/注册
    public struct Account {
        static let shared = Account()

        public var sendSms: APIItem { APIItem("/api/user/send_sms", d: "发送验证码", m: .post) }
        public var loginRegister: APIItem { APIItem("/api/user/login", d: "登录或者注册", m: .post) }
        public var loginOut: APIItem { APIItem("/api/user/loginOut", d: "退出", m: .post) }
        public var checkToken: APIItem { APIItem("/api/user/check_token", d: "token验证", m: .post) }
        public var loginPasswd: APIItem { APIItem("/api/user/login_by_password", d: "密码登录", m: .post) }
        public var changePasswd: APIItem { APIItem("/api/user/change_password", d: "修改密码", m: .post) }
        public var userInfo: APIItem { APIItem("/api/user/find_info", d: "获取用户信息", m: .get) }
        public var updateInfo: APIItem { APIItem("/api/user/update_info", d: "修改账户信息", m: .post) }
        public var minio: APIItem { APIItem("/api/resource/get_minio_config", d: "获取miniio配置", m: .get) }
    }
    
    
    
    // MARK: 用户
    public struct User {
        static let shared = User()
        
        public var rewardBill: APIItem { APIItem("/api/user/reward-bill", d: "账单") }
        public var wishBill: APIItem { APIItem("/api/user/wish-bill", d: "账单") }
        public var sendWish: APIItem { APIItem("/api/user/give-wish", d: "送祝福", m: .post) }
//        public var pay: APIItem { APIItem("/api/user/pay", d: "充值", m: .post) }
        public var logout: APIItem { APIItem("/api/user/logout", d: "退出", m: .post) }
        public var zhuxiao: APIItem { APIItem("/api/user/close", d: "退出", m: .post) }
        public var info: APIItem { APIItem("/api/user/info", d: "用户信息") }
        public var detail: APIItem { APIItem("/api/user/detail", d: "用户详情") }
        public var update: APIItem { APIItem("/api/user/update", d: "更新用户信息", m: .post) }
        public var updatePhone: APIItem { APIItem("/api/user/update-phone", d: "修改手机号", m: .post) }
        public var resetPassword: APIItem { APIItem("/api/user/password-reset", d: "重置密码", m: .post) }
        
        public var addFriend: APIItem { APIItem("/api/user/add-friend", d: "加好友", m: .post) }
        public var operateFriend: APIItem { APIItem("/api/user/handle-friend", d: "好友操作", m: .post) }
        public var friendList: APIItem { APIItem("/api/user/friends", d: "好友列表", m: .get) }
        public var signinArticle: APIItem { APIItem("/api/user/sign-in-article", d: "用户信息") }
        public var signin: APIItem { APIItem("/api/user/sign-in", d: "用户信息", m: .post) }
        public var reportTypes: APIItem { APIItem("/api/user/report-types", d: "用户信息") }
        public var reportRecords: APIItem { APIItem("/api/user/report-records", d: "举报记录") }
        public var reportUser: APIItem { APIItem("/api/user/report-user", d: "用户信息", m: .post) }
        public var messageSummary: APIItem { APIItem("/api/user/message-summary", d: "通知消息") }
        public var messages: APIItem { APIItem("/api/user/messages", d: "消息列表") }
        public var inviteSummary: APIItem { APIItem("/api/user/get-invite-summary", d: "通知消息") }
        public var setInvite: APIItem { APIItem("/api/user/set-invite-info", d: "", m: .post) }
        public var shield: APIItem { APIItem("/api/user/shield", d: "", m: .post) }
        public var shieldList: APIItem { APIItem("/api/user/get-shield-list", d: "屏蔽列表") }
    }
   
    
    
}
