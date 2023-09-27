import Photos
import ZLPhotoBrowser

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
                    MessageManager.shared.updateSDKUserInfo(kUserInfoModel) { success in
                        guard success else {
                            self.showToast("更新用户信息失败")
                            return
                        }
                        self.showToast("更新用户信息成功")
                    }
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
    
    var uploadedUrl: String = ""
    
    func upload(_ media: PHAsset, completion: @escaping (Bool) -> Void) {
        if media.mediaType == .image {
            ZLPhotoManager.fetchAssetFilePath(asset: media) { [weak self] filePath in
                guard let `self` = self else { return }
                guard let filePath = filePath, let fileURL = URL(string: filePath) else { return }
                var url: URL!
                if filePath.pathExtension == "HEIC" || filePath.pathExtension == "HEIF" {
                    if let newUrl = tt_convtHEICToJPG(fileURL: fileURL) {
                        url = newUrl
                    }
                } else if let newUrl = tt_copyFileToTempDir(fileURL: fileURL) {
                    url = newUrl
                }
                
                OIMManager.manager.uploadFile(
                    url.path,
                    name: url.lastPathComponent,
                    cause: nil) { [weak self] btyesSent, totalBytesSent, totalBytesExp in
                        guard let `self` = self else { return }
                        debugPrint(totalBytesSent, totalBytesExp)
                    } onCompletion: { totalBytes, url, putType in
                        debugPrint(totalBytes, "url:", url, putType)
                    } onSuccess: { [weak self] data in
                        guard let `self` = self else { return }
                        guard let data = data else { return }
                        let json = JSON(parseJSON: data)
                        let url = json["url"].stringValue
                        self.uploadedUrl = url
                        completion(true)
                    } onFailure: { code, msg in
                        debugPrint(code, msg)
                        completion(false)
                    }
            }
        }
    }
}
