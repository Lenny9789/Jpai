import Foundation
import Cache

/// Md5 after converting the parameter dictionary to a string
public func tt_cacheKey(_ url: String, _ params: Dictionary<String, Any>?, _ dynamicParams: Dictionary<String, Any>?) -> String {
    /// c参数重复, `params`中过滤掉`dynamicParams`中的参数
    if let filterParams = params?.filter({ (key, _) -> Bool in
        return dynamicParams?.contains(where: { (key1, _) -> Bool in
            return key != key1
        }) ?? false
    }) {
        let str = "\(url)" + "\(tt_sort(filterParams))"
        return MD5(str)
    } else {
        return MD5(url)
    }
}

/// Parameter sorting to generate string
public func tt_sort(_ parameters: Dictionary<String, Any>?) -> String {
    var sortParams = ""
    if let params = parameters {
        let sortArr = params.keys.sorted { return $0 < $1 }
        sortArr.forEach({ (str) in
            if let value = params[str] {
                sortParams = sortParams.appending("\(str)=\(value)")
            } else {
                sortParams = sortParams.appending("\(str)=")
            }
        })
    }
    return sortParams
}
