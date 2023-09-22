import UIKit

/// API接口请求
class APIService {
    static let shared = { APIService() }()
    
}

// MARK: 公共分类
extension APIService {
    
    
    //-MARK: 用户
    func sendSms(param: Param, completion: @escaping (TTGenericResult<JSON>) -> Void) {
        let headers: [String: String] = [:]
        TTNET.fetch(API.Account.shared.sendSms, parameters: param, headers: headers).result { result in
//            let parsedRet = parseResponseToModel(result: result, type: Int.self)
            switch result {
            case .success(let value):
                completion(.success(value: JSON(value)))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    func loginRegister(param: Param, completion: @escaping (TTGenericResult<JSON>) -> Void) {
        let headers: [String: String] = [:]
        TTNET.fetch(API.Account.shared.loginRegister, parameters: param, headers: headers).result { result in
//            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch result {
            case .success(let value):
                completion(.success(value: JSON(value)))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    func loginPasswd(param: Param, completion: @escaping (TTGenericResult<JSON>) -> Void) {
        let headers: [String: String] = [:]
        TTNET.fetch(API.Account.shared.loginPasswd, parameters: param, headers: headers).result { result in
//            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch result {
            case .success(let value):
                completion(.success(value: JSON(value)))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    func changePasswd(param: Param, completion: @escaping (TTGenericResult<JSON>) -> Void) {
        guard kUserToken.count > 0 else {
            return
        }
        let headers: [String: String] = ["token": kUserToken]
        TTNET.fetch(API.Account.shared.changePasswd, parameters: param, headers: headers).result { result in
//            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch result {
            case .success(let value):
                completion(.success(value: JSON(value)))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    func checkToken(completion: @escaping (TTGenericResult<JSON>) -> Void) {
        let headers: [String: String] = ["token": kUserToken]
        TTNET.fetch(API.Account.shared.checkToken, parameters: nil, headers: headers).result { result in
//            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch result {
            case .success(let value):
                completion(.success(value: JSON(value)))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    
    func fetchUserInfo(param: Param, completion: @escaping (TTGenericResult<JSON>) -> Void) {
        guard kUserToken.count > 0 else {
            return
        }
        let headers: [String: String] = ["token": kUserToken]
        
        TTNET.fetch(API.Account.shared.userInfo, parameters: param, headers: headers).result { result in
//            let parsedRet = parseResponseToModel(result: result, type: JpaiUserInfoModel.self)
            switch result {
            case .success(let value):
                completion(.success(value: JSON(value)))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    func searchUser(_ keyword: String, completion: @escaping (JSON) -> Void) {
        let param: Param = ["userid": keyword]
        fetchUserInfo(param: param) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let value):
                if value["status"].intValue == 200 && value["data"]["Id"].intValue > 0 {
                    completion(JSON(value["data"]))
                } else {
                    let param2: Param = ["phone": keyword]
                    self.fetchUserInfo(param: param2) { res in
                        switch res {
                        case .success(let value):
                            if value["status"].intValue == 200 {
                                completion(JSON(value["data"]))
                            }
                            
                        case .failure(let error):
                            debugPrint(error)
                        }
                    }
                }
                
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func updateUserInfo(param: Param, completion: @escaping (TTGenericResult<JSON>) -> Void) {
        guard kUserToken.count > 0 else {
            return
        }
        let headers: [String: String] = ["token": kUserToken]
        TTNET.fetch(API.Account.shared.updateInfo, parameters: param, headers: headers).result { result in
//            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch result {
            case .success(let value):
                completion(.success(value: JSON(value)))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
   
    func fetchRTCData(param: Param, completion: @escaping (TTGenericResult<JSON>) -> Void) {
        guard kUserToken.count > 0 else {
            return
        }
        let headers: [String: String] = ["token": kUserToken]
        let api = APIRTCItem("/app/v1/login", m: .get)
        TTNET.fetch(api, parameters: param, headers: headers).result { result in
            //            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch result {
            case .success(let value):
                completion(.success(value: JSON(value)))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    func fetchMinio(completion: @escaping (TTGenericResult<JSON>) -> Void) {
        guard kUserToken.count > 0 else {
            return
        }
        let headers: [String: String] = ["token": kUserToken]
        let api = API.Account.shared.minio
        TTNET.fetch(api, parameters: [:], headers: headers).result { result in
            //            let parsedRet = parseResponseToModel(result: result, type: String.self)
            switch result {
            case .success(let value):
                completion(.success(value: JSON(value)))
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
}
