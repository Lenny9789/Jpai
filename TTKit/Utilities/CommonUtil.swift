import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork

/// 获取`UUID`
public var tt_compactUUID: String {
    return UUID().uuidString
        .replacingOccurrences(of: "-", with: "")
        .lowercased()
}

// 获取iOS设备唯一标识UUID
public var tt_uniqueIdentifier: String {
    if let idfv = UIDevice.current.identifierForVendor?.uuidString.lowercased() {
        let udid = idfv
            .replacingOccurrences(of: "-", with: "")
            .lowercased()
        return udid
    }
    
    if let uuid = kGetObjectFromUserDefaults(key: "TTUniqueIdentifier") {
        return uuid as! String
    }
    
    let uuid = tt_compactUUID
    kSaveObjectToUserDefaults(key: "TTUniqueIdentifier", value: uuid)
    return uuid
}

/// 获取Wi-Fi名称（https://www.jianshu.com/p/1e10b927c2ca）
public func tt_getWifiSSID() -> String? {
    var ssid: String?
    if let interfaces = CNCopySupportedInterfaces() as NSArray? {
        for interface in interfaces {
            if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                break
            }
        }
    }
    return ssid
}

/// 获得公网IP（把数据变为json 在解析）
public func tt_getPublicIP(backBlock: @escaping ((_ ipStr: String)->())) {
    let queue = OperationQueue()
    let blockOP = BlockOperation.init {
        if let url = URL(string: "http://pv.sohu.com/cityjson?ie=utf-8") ,
            let s = try? String(contentsOf: url, encoding: String.Encoding.utf8) {
            debugPrint("data:\(s)")
            let subArr = s.components(separatedBy: ":")
            if subArr.count > 1  {
                let ipStr = subArr[1].replacingOccurrences(of: "\"", with: "")
                let ipSubArr = ipStr.components(separatedBy: ",")
                if ipSubArr.count > 0 {
                    let ip = ipSubArr[0].trimmingCharacters(in: CharacterSet.whitespaces)
                    debugPrint("公网IP:\(ip), Thread = \(Thread.current)")
                    DispatchQueue.main.async {
                        backBlock(ip)
                    }
                    return
                }
            }
        } else {
            debugPrint("获得公网IP URL 转换失败")
        }
        DispatchQueue.main.async {
            backBlock("")
        }
    }
    queue.addOperation(blockOP)
}

/// 获取本机运营商IP（联通/移动/电信的运营商给的移动IP）
public func tt_getOperatorsIP() -> String? {
    var addresses = [String]()
    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while (ptr != nil) {
            let flags = Int32(ptr!.pointee.ifa_flags)
            var addr = ptr!.pointee.ifa_addr.pointee
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        if let address = String(validatingUTF8:hostname) {
                            addresses.append(address)
                        }
                    }
                }
            }
            ptr = ptr!.pointee.ifa_next
        }
        freeifaddrs(ifaddr)
    }
    return addresses.first
}

/// 获取本机无线局域网ip
public func tt_getWifiIP() -> String? {
    var address: String?
    var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
    guard getifaddrs(&ifaddr) == 0 else {
        return nil
    }
    guard let firstAddr = ifaddr else {
        return nil
    }
     
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let interface = ifptr.pointee
        // Check for IPV4 or IPV6 interface
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
            // Check interface name
            let name = String(cString: interface.ifa_name)
            if name == "en0" {
                // Convert interface address to a human readable string
                var addr = interface.ifa_addr.pointee
                var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(&addr,socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostName)
            }
        }
    }
     
    freeifaddrs(ifaddr)
    return address
}
