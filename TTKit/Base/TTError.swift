import Foundation

/// Request error feedback, inherit `NSObject` so that OC can also call
public class TTError: NSObject, Error {
    public typealias UserInfo = [String: Any]

    /// error code
    @objc public var code: Int
    /// error message
    @objc public var localizedDescription: String
    /// ext info
    @objc public var userInfo: UserInfo?

    public enum GeneralErrorCode: Int {
        // 一般错误
        case generalError           = -1
        // 无效的数据
        case invalidData            = -9001
        // 无法解析数据
        case unResolved             = -9002
        // 潜在错误
        case underlyingError        = -9999
        // API网络连接断开
        case apiConnectLost         = 13
        // Resource网络连接断开
        case resourceConnectLost    = 2003
        // 请求取消
        case requestCanceled        = 15

        // 翻译错误描述
        var message: String {
            switch self {
            case .generalError:
                return ""
            case .invalidData:
                return .localized_invalid_data
            case .unResolved:
                return .localized_un_uesolved
            case .underlyingError:
                return ""
            case .apiConnectLost:
                return .localized_net_connect_lost
            case .resourceConnectLost:
                return .localized_net_connect_lost
            case .requestCanceled:
                return .localized_request_canceled
            }
        }
        
        // 匹配网络请求错误码描述
        static func matchedDesc(code: Int) -> String? {
            if code == self.apiConnectLost.rawValue {
                let generalEC: GeneralErrorCode = .apiConnectLost
                return generalEC.message
            } else if code == self.resourceConnectLost.rawValue {
                let generalEC: GeneralErrorCode = .resourceConnectLost
                return generalEC.message
            } else if code == self.requestCanceled.rawValue {
                let generalEC: GeneralErrorCode = .requestCanceled
                return generalEC.message
            } else {
                return nil
            }
        }
    }
    
    public override init() {
        self.code = GeneralErrorCode.underlyingError.rawValue
        self.localizedDescription = ""
        super.init()
    }
    
    public init(code: Int, desc: String, userInfo: UserInfo? = nil) {
        self.code = code
        if let mDesc = GeneralErrorCode.matchedDesc(code: code) {
            self.localizedDescription = mDesc
        } else {
            self.localizedDescription = desc
        }
        self.userInfo = userInfo
        super.init()
    }

    public init(code: GeneralErrorCode, desc: String? = nil, userInfo: UserInfo? = nil) {
        self.code = code.rawValue
        self.localizedDescription = (desc ?? code.message)
        self.userInfo = userInfo
        super.init()
    }
}
