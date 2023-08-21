import UIKit
#if canImport(Kingfisher)
import Kingfisher
#endif

@objc extension UIButton {

    /// 设置网络url
    public func setImage(withURL url: URL?, placeholderImage: UIImage?) {
        self.setImage(placeholderImage, for: .normal)
        #if canImport(Kingfisher)
        if let url = url {
            self.kf.setImage(with: .network(ImageResource(downloadURL: url)), for: .normal, placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    let err = TTError(code: error.errorCode, desc: error.errorDescription ?? "")
                    let errInfo = RequestErrorInfo(error: err, url: url)
                    NotificationCenter.default.post(name: TTNotifyName.Kit.imageRequestError, object: errInfo)
                    break
                }
            }
        }
        #endif
    }

    /// 设置背景网络url
    public func setBackgroundImage(withURL url: URL?, placeholderImage: UIImage?) {
        self.setBackgroundImage(placeholderImage, for: .normal)
        #if canImport(Kingfisher)
        if let url = url {
            self.kf.setBackgroundImage(with: .network(ImageResource(downloadURL: url)), for: .normal, placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    let err = TTError(code: error.errorCode, desc: error.errorDescription ?? "")
                    let errInfo = RequestErrorInfo(error: err, url: url)
                    NotificationCenter.default.post(name: TTNotifyName.Kit.imageRequestError, object: errInfo)
                    break
                }
            }
        }
        #endif
    }
}
