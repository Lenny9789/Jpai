import Foundation

/// Dictionary -> Data
public func tt_jsonToData(_ jsonDic: Dictionary<String, Any>) -> Data? {
    if (!JSONSerialization.isValidJSONObject(jsonDic)) {
        debugPrint("is not a valid json object")
        return nil
    }
    
    let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
 
    return data
}

/// Data -> Dictionary
public func tt_dataToDictionary(_ data: Data) ->Dictionary<String, Any>? {
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
 
        let dic = json as! Dictionary<String, Any>
 
        return dic
    } catch _ {
        debugPrint("convert failed")
        
        return nil
    }
}

/// Dictionary -> String
public func tt_jsonToString(_ jsonDic: Dictionary<String, Any>,
                            encoding: String.Encoding = .utf8) -> String? {
    if (!JSONSerialization.isValidJSONObject(jsonDic)) {
        debugPrint("is not a valid json object")
        return nil
    }
    
    //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
    let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: .prettyPrinted)
    let str = String(data:data!, encoding: String.Encoding.utf8)
   
    return str
}

/// String -> Dictionary
public func tt_stringToJson(jsonStr: String) -> Dictionary<String, Any>? {
    do {
        let data: Data = jsonStr.data(using: .utf8)!

        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
  
        return json as? Dictionary<String, Any>
    } catch _ {
        debugPrint("convert failed")
        
        return nil
    }
}

/// String -> Array
public func tt_stringToArray(jsonStr: String) -> Array<Any>? {
    do {
        let data: Data = jsonStr.data(using: .utf8)!

        let array = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
  
        return array as? Array<Any>
    } catch _ {
        debugPrint("convert failed")
        
        return nil
    }
}
