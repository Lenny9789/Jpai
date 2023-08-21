import Foundation

/// 业务层错误码定义
extension TTError {
    /// 服务端错误码
    public enum ServerErrorCode: Int {
        // 成功
        case success                = 200
        // Token过期
        case tokenExpired           = 1
        // token为空
        case tokenEmpty             = 401
        // 聊天：被屏蔽
        case chatBlocked            = 10201
        // 聊天：被禁言
        case chatMute               = 10202
        // 聊天：全体禁言
        case chatAllMute            = 10203
        // 聊天：群聊不存在
        case chatGroupNotExist      = 10204

        var message: String {
            switch self {
            case .tokenExpired:
                return .localized_token_expired
            case .tokenEmpty:
                return .localized_token_empty
            case .chatBlocked:
                return ""
            case .chatMute:
                return ""
            case .chatAllMute:
                return ""
            case .chatGroupNotExist:
                return ""
            default:
                return ""
            }
        }
    }
    
    /// 客户端自定义错误码
    public enum ClientErrorCode: Int {
        case connectionLost     = 9001
        case invalidOperate     = 9002
        case handleException    = 9003
        
        var message: String {
            switch self {
            default:
                return ""
            }
        }
    }
    
    public convenience init(code: ServerErrorCode, desc: String? = nil, userInfo: UserInfo? = nil) {
        self.init()
        self.code = code.rawValue
        self.localizedDescription = (desc ?? code.message)
        self.userInfo = userInfo
    }
    
    public convenience init(code: ClientErrorCode, desc: String? = nil, userInfo: UserInfo? = nil) {
        self.init()
        self.code = code.rawValue
        self.localizedDescription = (desc ?? code.message)
        self.userInfo = userInfo
    }
}
