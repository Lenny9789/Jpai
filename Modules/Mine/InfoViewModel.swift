
class InfoViewModel: BaseViewModel {

    init(apiService: APIService = .shared) {
        super.init()
        self.apiService = apiService
        setupAlertDelegator(with: self)
    }
    
    
    
    var intro: String = ""
    var NickName: String = ""
    var realName: String = ""
    var selectedSex: Int = 0
    var birthDate: String = ""
    
    let rx_didUploadSuccess = PublishSubject<Void>()
    var avatar: String = ""
    
//    func uploadImage(resuorcesPayload: ResourcePayload) {
//        showLoader()
//        _ = apiService?.uploadFile(file: resuorcesPayload, onProgress: { progress in
//            debugPrint(progress)
//        }, onCompletion: { [weak self] result in
//            guard let `self` = self else { return }
//            self.hideLoader()
//            switch result {
//            case .success(let model):
//                debugPrint(model)
//                self.avatar = model
//                self.rx_didUploadSuccess.onNext(())
//            case .failure(let error):
//                self.showToast(error.localizedDescription)
//            }
//        })
//    }
    
    let rx_didUpdateSuccess = PublishSubject<Void>()
    
    func updateInfo(_ param: Param) {
        showLoader()
        apiService?.updateUserInfo(param: param, completion: { [weak self] result in
            guard let `self` = self else { return }
            self.hideLoader()
            switch result {
            case .success(_):
                self.fetchUserInfo { success in
                    guard success else {
                        return
                    }
                    self.rx_didUpdateSuccess.onNext(())
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self.showToast(error.localizedDescription)
            }
        })
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
