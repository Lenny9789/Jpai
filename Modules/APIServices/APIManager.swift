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
        public var checkToken: APIItem { APIItem("/api/user/check_token", d: "token验证", m: .post) }
        public var loginPasswd: APIItem { APIItem("/api/user/login_by_password", d: "密码登录", m: .post) }
        public var changePasswd: APIItem { APIItem("/api/user/change_password", d: "修改密码", m: .post) }
        public var userInfo: APIItem { APIItem("/api/user/find_info", d: "获取用户信息", m: .post) }
        public var updateInfo: APIItem { APIItem("/api/user/update_info", d: "修改账户信息", m: .post) }
    }
    
    // MARK: 我的家族
    public struct Family {
        static let shared = Family()

        public var list: APIItem { APIItem("/api/family/list", d: "家族列表", m: .get) }
        public var detail: APIItem { APIItem("/api/family/detail", d: "家族列表", m: .get) }
        public var member: APIItem { APIItem("/api/family/member", d: "家族列表", m: .get) }
        public var saveFamliy: APIItem { APIItem("/api/family/save", d: "创建更新家族", m: .post) }
        public var saveMember: APIItem { APIItem("/api/family/member-save", d: "创建更新成员", m: .post) }
        public var deleteMember: APIItem { APIItem("/api/family/member-delete", d: "创建更新成员", m: .post) }
        public var deleteFamily: APIItem { APIItem("/api/family/delete", d: "删除成员", m: .post) }
        public var saveAlert: APIItem { APIItem("/api/alert/save", d: "创建提醒", m: .post) }
        public var alertList: APIItem { APIItem("/api/alert/list", d: "家族列表", m: .get) }
        public var deleteAlert: APIItem { APIItem("/api/alert/delete", d: "删除提醒", m: .post) }
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
    
    // MARK: 纪念馆
    public struct Memorial {
        static let shared = Memorial()
        
        public var list: APIItem { APIItem("/api/memorial/list", d: "纪念馆列表") }
        public var memorialHall: APIItem { APIItem("/api/memorial/memorial-halls", d: "纪念馆大厅") }
        public var like: APIItem { APIItem("/api/memorial/like", d: "纪念馆收藏", m: .post) }
        public var sendWish: APIItem { APIItem("/api/memorial/give-memorial-wish", d: "纪念馆收藏", m: .post) }
        public var addMember: APIItem { APIItem("/api/memorial/add-member", d: "纪念馆收藏", m: .post) }
        public var upload: APIItem { APIItem("/api/memorial/upload-material", d: "纪念馆上传图片视频", m: .post) }
        public var materials: APIItem { APIItem("/api/memorial/materials", d: "纪念馆图片视频") }
        public var userOwnerList: APIItem { APIItem("/api/memorial/user-memorials", d: "纪念馆详情") }
        public var detail: APIItem { APIItem("/api/memorial/detail", d: "纪念馆详情") }
        public var save: APIItem { APIItem("/api/memorial/save", d: "创建或更新", m: .post) }
        public var delete: APIItem { APIItem("/api/memorial/delete", d: "纪念馆删除", m: .post) }
        public var deleteMaterial: APIItem { APIItem("/api/memorial/delete-material", d: "纪念馆删除", m: .post) }
        public var transfer: APIItem { APIItem("/api/memorial/transfer", d: "转移", m: .post) }
        public var receive: APIItem { APIItem("/api/memorial/receive", d: "接收", m: .post) }
        public var sg: APIItem { APIItem("/api/memorial/sg", d: "放置贡品", m: .post) }
        public var gpList: APIItem { APIItem("/api/memorial/gps", d: "获取所有贡品") }
        public var user_gps: APIItem { APIItem("/api/memorial/user-gps", d: "纪念馆里的贡品") }
        public var userMissVList: APIItem { APIItem("/api/memorial/user-miss-v-list", d: "思念值排行") }
        public var userEvents: APIItem { APIItem("/api/memorial/user-events", d: "用户事件列表") }
        public var leaveMessage: APIItem { APIItem("/api/memorial/leave-message", d: "留言", m: .post) }
        public var leaveMessages: APIItem { APIItem("/api/memorial/leave-messages", d: "留言列表") }
        public var metrics: APIItem { APIItem("/api/memorial/get-user-memorial-metrics", d: "留言列表") }
    }
    // MARK: 首页
    public struct Home {
        static let shared = Home()

        public var homeModules: APIItem { APIItem("/api/home/homeModules", d: "首页模块") }
        public var activityList: APIItem { APIItem("/api/home/activityList", d: "活动列表") }
        public var activityDetail: APIItem { APIItem("/api/home/activityDetail", d: "活动详情") }
    }
    
    
}
