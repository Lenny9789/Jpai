import UIKit

/// API接口请求
class APIService {
    static let shared = { APIService() }()
    
}

// MARK: 公共分类
extension APIService {
    
    
    //-MARK: 用户
    func loginOneClick(token: String, completion: @escaping (TTGenericResult<OneClickDataModel>) -> Void) {
        var parameter = [String: String]()
        let headers: [String: String] = [:]
        parameter["token"] = token
        TTNET.fetch(API.Account.shared.loginOneClick, parameters: parameter, headers: headers).result { result in
            let parsedRet = parseResponseToModel(result: result, type: OneClickDataModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! OneClickDataModel))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    func loginFetchCaptcha(phone: String, completion: @escaping (TTBooleanResult) -> Void) {
        let parameter: [String: Any] = ["phone": phone]
        let headers: [String: String] = [:]
        
        TTNET.fetch(API.Account.shared.loginFetchCaptcha, parameters: parameter, headers: headers).result { result in
            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch parsedRet {
            case .success(_):
                completion(.success)
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    func loginCaptcha(phone: String, code: String, completion: @escaping (TTGenericResult<OneClickDataModel>) -> Void) {
        let parameter: [String: Any] = ["phone": phone, "code": code]
        let headers: [String: String] = [:]
        TTNET.fetch(API.Account.shared.loginCaptcha, parameters: parameter, headers: headers).result { result in
            let parsedRet = parseResponseToModel(result: result, type: OneClickDataModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! OneClickDataModel))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    func loginPwd(account: String, pwd: String, completion: @escaping (TTGenericResult<OneClickDataModel>) -> Void) {
        let parameter: [String: Any] = ["account": account, "password": pwd]
        let headers: [String: String] = [:]
        TTNET.fetch(API.Account.shared.loginPwd, parameters: parameter, headers: headers).result { result in
            let parsedRet = parseResponseToModel(result: result, type: OneClickDataModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! OneClickDataModel))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    //-MARK: w我的家族
    func familyList(completion: @escaping (TTGenericResult<[FamilyListModel]>) -> Void) {
        let header = ["token": kUserToken]
        
            TTNET.fetch(API.Family.shared.list, parameters: nil, headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: FamilyListModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! [FamilyListModel]))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    func familyDetail(param: [String: Any],
                      completion: @escaping (TTGenericResult<FamilyListModel>) -> Void) {
        let header = ["token": kUserToken]
        
            TTNET.fetch(API.Family.shared.detail, parameters: param, headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: FamilyListModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! FamilyListModel))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    // 创建更新家族
    func familySave(
        param: [String: Any],
        completion: @escaping (TTGenericResult<String>) -> Void) {
        let header = ["token": kUserToken]
        
            TTNET.fetch(API.Family.shared.saveFamliy, parameters: param, headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! String))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    // 创建更新成员
    func familyMemberSave(
        param: [String: Any],
        completion: @escaping (TTGenericResult<String>) -> Void) {
        let header = ["token": kUserToken]
        
            TTNET.fetch(API.Family.shared.saveMember, parameters: param, headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! String))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    // 删除
    func familyDelete(
        param: [String: Any],
        completion: @escaping (TTGenericResult<String>) -> Void) {
        let header = ["token": kUserToken]
        
            TTNET.fetch(API.Family.shared.deleteFamily, parameters: param, headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! String))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    func memberDelete(
        param: [String: Any],
        completion: @escaping (TTGenericResult<String>) -> Void) {
        let header = ["token": kUserToken]
        
            TTNET.fetch(API.Family.shared.deleteMember, parameters: param, headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! String))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    // 创建更新提醒
    func familyAlertSave(
        param: [String: Any],
        completion: @escaping (TTGenericResult<String>) -> Void) {
        let header = ["token": kUserToken]
        
            TTNET.fetch(API.Family.shared.saveMember, parameters: param, headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! String))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    // -MARK: 纪念馆
    // 创建纪念馆
    func fetchMemorialSave(
        param: [String: Any],
        completion: @escaping (TTGenericResult<MemorialCreatModel>) -> Void) {
        let header = ["token": kUserToken]
        
            TTNET.fetch(API.Memorial.shared.save, parameters: param, headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: MemorialCreatModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! MemorialCreatModel))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    //获取纪念馆列表
    func fetchMemorials(
        param: [String: Any],
        completion: @escaping (TTGenericResult<MemorialListModel>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.list,
                    parameters: param,
                    headers: header).result { result in
        let parsedRet = parseResponseToModel(result: result, type: MemorialListModel.self)
        switch parsedRet {
        case .success(let value):
            completion(.success(value: value as! MemorialListModel))
        case .failure(let error):
            completion(.failure(error: error))
        }
        }
    }
    func fetchMemorialHall(
        param: [String: Any],
        completion: @escaping (TTGenericResult<MemorialListModel>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.memorialHall,
                    parameters: param,
                    headers: header).result { result in
        let parsedRet = parseResponseToModel(result: result, type: MemorialListModel.self)
        switch parsedRet {
        case .success(let value):
            completion(.success(value: value as! MemorialListModel))
        case .failure(let error):
            completion(.failure(error: error))
        }
        }
    }
    // 用户拥有的纪念馆
    func fetchOwnerMemorials(
        param: [String: Any],
        completion: @escaping (TTGenericResult<MemorialListModel>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.userOwnerList,
                    parameters: param,
                    headers: header).result { result in
        let parsedRet = parseResponseToModel(result: result, type: MemorialListModel.self)
        switch parsedRet {
        case .success(let value):
            completion(.success(value: value as! MemorialListModel))
        case .failure(let error):
            completion(.failure(error: error))
        }
        }
    }
    
    //上传图片视频
    func uploadMemorialsRes(
        param: [String: Any],
        completion: @escaping (TTGenericResult<String>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.upload,
                    parameters: param,
                    headers: header).result { result in
        let parsedRet = parseResponseToModel(result: result, type: String.self)
        switch parsedRet {
        case .success(let value):
            completion(.success(value: value as! String))
        case .failure(let error):
            completion(.failure(error: error))
        }
        }
    }
    //获取图片视频
    func fetchMemorialsRes(
        param: [String: Any],
        completion: @escaping (TTGenericResult<MemorialsResModel>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.materials,
                    parameters: param,
                    headers: header).result { result in
        let parsedRet = parseResponseToModel(result: result, type: MemorialsResModel.self)
        switch parsedRet {
        case .success(let value):
            completion(.success(value: value as! MemorialsResModel))
        case .failure(let error):
            completion(.failure(error: error))
        }
        }
    }
    //收藏
    func likeMemorial(
        param: [String: Any],
        completion: @escaping (TTGenericResult<String>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.like,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! String))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    func sendWishMemorial(
        param: Param,
        completion: @escaping (TTGenericResult<MemorialMetricsModel>) -> Void
    ) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.sendWish,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: MemorialMetricsModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! MemorialMetricsModel))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    //
    func memorialAddMember(
        param: [String: Any],
        completion: @escaping (TTGenericResult<String>) -> Void) {
            let header = ["token": kUserToken]
            
            TTNET.fetch(API.Memorial.shared.addMember,
                        parameters: param,
                        headers: header).result { result in
                let parsedRet = parseResponseToModel(result: result, type: String.self)
                switch parsedRet {
                case .success(let value):
                    completion(.success(value: value as! String))
                case .failure(let error):
                    completion(.failure(error: error))
                }
            }
        }
    
    //删除
    func memorialDelete(
        param: [String: Any],
        completion: @escaping (TTGenericResult<String>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.delete,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! String))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    func memorialMaterialDelete(
        param: [String: Any],
        completion: @escaping (TTGenericResult<String>) -> Void) {
            let header = ["token": kUserToken]
            
            TTNET.fetch(API.Memorial.shared.deleteMaterial,
                        parameters: param,
                        headers: header).result { result in
                let parsedRet = parseResponseToModel(result: result, type: String.self)
                switch parsedRet {
                case .success(let value):
                    completion(.success(value: value as! String))
                case .failure(let error):
                    completion(.failure(error: error))
                }
            }
        }
    
    //转让
    func memorialTansfer(
        param: [String: Any],
        completion: @escaping (TTGenericResult<String>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.transfer,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! String))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    //接收
    func memorialTansferReceive(
        param: [String: Any],
        completion: @escaping (TTGenericResult<String>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.receive,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! String))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    //-MARK: 思念值排行
    func memorialMissVList(param: [String: Any],
                           completion: @escaping (TTGenericResult<MissVListModel>) -> Void) {
        let header = ["token": kUserToken]

        TTNET.fetch(API.Memorial.shared.userMissVList,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: MissVListModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! MissVListModel))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    //-MARK: 事件列表
    func memorialEventList(param: [String: Any],
                           completion: @escaping (TTGenericResult<EventListModel>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.userEvents,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: EventListModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! EventListModel))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    //-MARK: 留言
    func leaveMessage(param: Param,
                      completion: @escaping (TTGenericResult<MemorialMetricsModel>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.leaveMessage,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: MemorialMetricsModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! MemorialMetricsModel))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    //-MARK: 所有贡品列表
    func memorialTributes(completion: @escaping (TTGenericResult<[MemorialTributeModel]>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.gpList,
                    parameters: nil,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: MemorialTributeModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! [MemorialTributeModel]))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    //-MARK: 已经放置的贡品
    func memorialExistingTributes(param: [String: Any],
                           completion: @escaping (TTGenericResult<[ExistingTributeModel]>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.user_gps,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: ExistingTributeModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! [ExistingTributeModel]))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    //-MARK: 上供
    func memorialPlaceTributes(param: [String: Any],
                           completion: @escaping (TTGenericResult<String>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.sg,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! String))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    //-MARK:
    func memorialMetrics(param: [String: Any],
                         completion: @escaping (TTGenericResult<MemorialMetricsModel>) -> Void) {
        let header = ["token": kUserToken]
        
        TTNET.fetch(API.Memorial.shared.metrics,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: MemorialMetricsModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! MemorialMetricsModel))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    // -MARK: 好友
    func friendList(completion: @escaping (TTGenericResult<[FriendListItemModel]>) -> Void) {
        let header = ["token": kUserToken]
        let param: [String: Any] = ["type": "ok"]
        TTNET.fetch(API.User.shared.friendList,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: FriendListItemModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! [FriendListItemModel]))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    /// --Mark 黑名单
    func friendListBlack(completion: @escaping (TTGenericResult<[FriendListItemModel]>) -> Void) {
        let header = ["token": kUserToken]
        let param: [String: Any] = ["type": "black"]
        TTNET.fetch(API.User.shared.friendList,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: FriendListItemModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! [FriendListItemModel]))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    // 好友请求
    func friendRequests(completion: @escaping (TTGenericResult<[FriendsModel]>) -> Void) {
        let header = ["token": kUserToken]
        let param: [String: Any] = ["type": "todo"]
        TTNET.fetch(API.User.shared.friendList,
                    parameters: param,
                    headers: header).result { result in
            let parsedRet = parseResponseToModel(result: result, type: FriendsModel.self)
            switch parsedRet {
            case .success(let value):
                completion(.success(value: value as! [FriendsModel]))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    
    
}