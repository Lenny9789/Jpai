
import UIKit
@_exported import RxSwift
@_exported import Rswift
@_exported import RxCocoa
@_exported import RxSwiftExt
@_exported import WHC_Layout
@_exported import Then
@_exported import SwifterSwift
@_exported import RxGesture
@_exported import GKNavigationBarSwift
@_exported import SwiftyUserDefaults
@_exported import CleanJSON

public typealias Param = [String: Any]

let kATAUSDKKey = "47Gs8aadQoefREn4XNXosTaK1Ljes9wqhiRAx8zQU931VZpHmxmRHlw5pNo9YUAn/5sfQTMJyucDV4PpN+ZmbybbFD6PqaVYqIQkIjwxqn2pc0nzNorh29WykL7Ns0BWjMfquK1iMNkDuDxAu/kgYxrhmWegoY6FDS4vyhHMezWErpZh5dydUNbU7OXdIaqlysT9hmBY9Dn/EtiGhg3OqHMFut5G8RBb73ZfXrRVluOUmDMHsOzpo3y6T7+Ihb9jK45rczstGzXm850uLrQn9g=="

let wxAppId = "wx17e3cbf2e6d40981"

/// 获取AppDelegate
let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

let kMainColor = UIColor(hex: "0x00a9ff")

let kMainbackgroundcolor = UIColor(hex: "0xf5f5f5")

let kMainNavBackImage = UIImage(named: "home_nav_bg")
// 视频播放视图Tag
let kPlayerContainerViewTag = 1012

private let testDomain = "https://www.minghaimuyuan.vip"
private let prodDomain = "https://www.minghaimuyuan.xyz"
let kAppDomain = prodDomain

var kUserToken: String {
    set {
        Defaults[\.userToken] = newValue
    }
    get {
        return Defaults[\.userToken]
    }
}

var kUserModel: UserModel! {
    set {
        Defaults[\.userModelString] = newValue.toJSONString() ?? ""
    }
    get {
        guard kUserToken.count > 0 else {
            return UserModel()
        }
        
        let modelStr = Defaults[\.userModelString]
        guard modelStr.count > 0 else {
            return UserModel()
        }
        
        let model = try! CleanJSONDecoder.decode(modelStr, to: UserModel.self)
        return model
    }
}

var kUserDetailModel: UserDetail! {
    set {
        Defaults[\.userDetailString] = newValue.toJSONString() ?? ""
    }
    get {
        guard kUserToken.count > 0 else {
            return UserDetail()
        }
        
        let modelStr = Defaults[\.userDetailString]
        guard modelStr.count > 0 else {
            return UserDetail()
        }
        
        let model = try! CleanJSONDecoder.decode(modelStr, to: UserDetail.self)
        return model
    }
}

var kOSSTokenModel: OSSPolicyModel! {
    set {
        Defaults[\.ossTokenString] = newValue.toJSONString() ?? ""
    }
    get {
        let modelStr = Defaults[\.ossTokenString]
        guard modelStr.count > 0 else {
            return OSSPolicyModel()
        }
        
        let model = try! CleanJSONDecoder.decode(modelStr, to: OSSPolicyModel.self)
        return model
    }
}

extension DefaultsKeys {
    var userToken: DefaultsKey<String> {
        .init("userToken", defaultValue: "")
    }
    
    var userModelString: DefaultsKey<String> {
        .init("userModelString", defaultValue: "")
    }
    
    var userDetailString: DefaultsKey<String> {
        .init("userDetailString", defaultValue: "")
    }
    
    var ossTokenString: DefaultsKey<String> {
        .init("ossTokenString", defaultValue: "")
    }
}


extension TTNotifyName.App {
    
    public static let needLogin = Notification.Name(rawValue: "needLogin")
    public static let didVideoPresent = Notification.Name(rawValue: "didVideoPresent")
    public static let didVideoDismiss = Notification.Name(rawValue: "didVideoDismiss")
    public static let alipResult = Notification.Name(rawValue: "alipResult")
    public static let wepResult = Notification.Name(rawValue: "wepResult")
}
extension Data {
    //将Data转换为String
    var hexString: String {
        return withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> String in
            let buffer = UnsafeBufferPointer(start: bytes, count: count)
            return buffer.map {String(format: "%02hhx", $0)}.reduce("", { $0 + $1 })
        }
    }
}
