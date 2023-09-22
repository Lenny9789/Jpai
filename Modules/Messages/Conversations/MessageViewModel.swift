
class MessageViewModel: BaseViewModel {

    init(apiService: APIService = .shared) {
        super.init()
        self.apiService = apiService
        setupAlertDelegator(with: self)
    }
    
    var conversationList: [OIMConversationInfo] = []
    
    func fetchConversitionList(completion: @escaping (Bool) -> Void) {
        guard kUserToken.count > 0 else {
            conversationList = []
            completion(false)
            return
        }
        
        OIMManager.manager.getAllConversationListWith { [weak self] list in
            guard let `self` = self else { return }
            guard let list = list else { return }
            self.conversationList = list
            completion(true)
        }
    }
    
    func fetchUserInfo(completion: @escaping (Bool) -> Void) {
        let param: Param = ["userid": kUserLoginModel["Id"].intValue]
        APIService.shared.fetchUserInfo(param: param) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let model):
                if model["status"].intValue == 200 {
                    kUserInfoModel = model["data"]
                    completion(true)
                } else {
                    self.showToast(model["msg"].stringValue)
                    completion(false)
                }
            case .failure(let error):
                self.showToast(error.localizedDescription)
                completion(false)
            }
        }
    }
}
