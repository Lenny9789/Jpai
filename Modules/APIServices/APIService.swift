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
}
