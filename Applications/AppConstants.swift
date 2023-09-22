
import UIKit
@_exported import RxSwift
@_exported import Rswift
@_exported import RxCocoa
@_exported import RxSwiftExt
@_exported import RxBinding
@_exported import WHC_Layout
//@_exported import Then
@_exported import SwifterSwift
@_exported import RxGesture
@_exported import GKNavigationBarSwift
@_exported import SwiftyUserDefaults
@_exported import CleanJSON
@_exported import SwiftyJSON
@_exported import OpenIMSDK
//@_exported import OUIIM
//@_exported //import OUICore
//@_exported //import OUICoreView

public typealias Param = [String: Any]

let kApiAddress = "http://im.myjpai.com/api"//"http://220.173.138.144:10002"
let kWsAddress = "ws://im.myjpai.com/msg_gateway"//"ws://220.173.138.144:10001"
let kAppDomain = "http://user.myjpai.com"//"http://220.173.138.144:19804"//prodDomain
let kRTCDomain = "http://www.myjpai.com:10088"//prodDomain
var localDebugIP = "http://192.168.31.104:5173/login"


/// 获取AppDelegate
let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

let kMainColor = UIColor(hex: "0x00a9ff")

let kMainbackgroundcolor = UIColor(hex: "0xf5f5f5")

let kMainNavBackImage = UIImage(named: "home_nav_bg")
// 视频播放视图Tag
let kPlayerContainerViewTag = 1012

private let testDomain = "https://www.minghaimuyuan.vip"
private let prodDomain = "https://www.minghaimuyuan.xyz"



var kUserToken: String {
    set {
        Defaults[\.userToken] = newValue
    }
    get {
        return Defaults[\.userToken]
    }
}

var kUserLoginModel: JSON! {
    set {
        Defaults[\.userModelString] = newValue.toJSONString() ?? ""
    }
    get {
        guard kUserToken.count > 0 else {
            return JSON()
        }
        
        let modelStr = Defaults[\.userModelString]
        guard modelStr.count > 0 else {
            return JSON()
        }
        
        let model = JSON(parseJSON: modelStr)
        return model
    }
}

var kUserInfoModel: JSON! {
    set {
        Defaults[\.userDetailString] = newValue.toJSONString() ?? ""
    }
    get {
        guard kUserToken.count > 0 else {
            return JSON()
        }
        
        let modelStr = Defaults[\.userDetailString]
        guard modelStr.count > 0 else {
            return JSON()
        }
        
        let model = JSON(parseJSON: modelStr)
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
    public static let OIMSDKLoginSuccess = Notification.Name(rawValue: "OIMSDKLoginSuccess")
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


