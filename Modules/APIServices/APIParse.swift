import Foundation
import CleanJSON

/// 服务器返回基本模型
struct NetBaseResponse: Codable {
    /// 错误码
    var status: Int
    /// 错误提示
    var msg: String
    /// 业务数据
//    var data: String
    
    /// Json结构关键Key
    enum ReservedKey: String {
        case data = "data"
        case list = "list"
        case totalSize = "totalSize"
    }
}


/// 服务器返回的数据转成对象模型
public func parseResponseToModel<T : Decodable>(result: TTGenericResult<Any>,
                                                type: T.Type?) -> TTGenericResult<Any> {
    switch result {
    case .success(let response):
        if let respDic = response as? Dictionary<String, Any> {
            if let respData = tt_jsonToData(respDic){
                let baseModel = try? CleanJSONDecoder().decode(NetBaseResponse.self, from: respData)
                if let baseModel = baseModel {
                    if baseModel.status == TTError.ServerErrorCode.success.rawValue {
                        if let data = respDic[NetBaseResponse.ReservedKey.data.rawValue] {
                            if data is Array<Any> { //返回的是数组
                                if let type = type { //解析数据
                                    var retModels = [Any]()
                                    for itemDic in data as! Array<Any> {
                                        let itemData = tt_jsonToData(itemDic as! Dictionary<String, Any>)
                                        if let itemData = itemData {
                                            let itemModel = try? CleanJSONDecoder().decode(type, from: itemData)
                                            if let itemModel = itemModel {
                                                retModels.append(itemModel)
                                            }
                                        }
                                    }
                                    return .success(value: retModels)
                                } else { //不解析数据
                                    return .success(value: data)
                                }
                            } else if data is Dictionary<String, Any> { //返回的是对象
                                let dicData = data as! Dictionary<String, Any>
                                if let type = type { //解析数据
                                    if let dataDic = tt_jsonToData(dicData) {
                                        let retModel = try? CleanJSONDecoder().decode(type, from: dataDic)
                                        if let retModel = retModel {
                                            return .success(value: retModel)
                                        }
                                    }
                                } else { //不解析
                                    return .success(value: dicData)
                                }
                            } else {
                                return .success(value: data)
                            }
                        }
                    } else {
                        if baseModel.status == TTError.ServerErrorCode.tokenExpired.rawValue ||
                            baseModel.status == TTError.ServerErrorCode.tokenEmpty.rawValue {
                            NotificationCenter.default.post(name: TTNotifyName.App.needLogin, object: nil)
                        }
                        return .failure(error: TTError(code: baseModel.status, desc: baseModel.msg))
                    }
                }
            }
        }
        return .failure(error: TTError(code: .unResolved))
        
    case .failure(let error):
        if error.code == TTError.ServerErrorCode.tokenExpired.rawValue ||
            error.code == TTError.ServerErrorCode.tokenEmpty.rawValue {
            NotificationCenter.default.post(name: TTNotifyName.App.userNeedReLogin, object: nil)
        }
        return .failure(error: error)
    }
}
