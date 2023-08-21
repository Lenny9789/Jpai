import UIKit
#if canImport(Kingfisher)
import Kingfisher
#endif

extension UIImageView {

    /// Returns a date as a string in the provided format.
    ///
    /// - Parameters:
    ///     - url: An optional URL for the image to load.
    ///     - placeholderImage: An optional Image to be setting for `UIImageView` before network image loaded.
    ///
    public func setImage(withURL url: URL?, placeholderImage: UIImage?) {
        self.image = placeholderImage
        #if canImport(Kingfisher)
        if let url = url {
            self.kf.setImage(with: .network(ImageResource(downloadURL: url)), placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
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
    
    public func setImage(withURL url: URL?, placeholderImage: UIImage?, completion: @escaping (TTGenericResult<UIImage>) -> Void) {
        self.image = placeholderImage
        #if canImport(Kingfisher)
        if let url = url {
            self.kf.setImage(with: .network(ImageResource(downloadURL: url)), placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    completion(.success(value: value.image))
                case .failure(let error):
                    let err = TTError(code: error.errorCode, desc: error.errorDescription ?? "")
                    let errInfo = RequestErrorInfo(error: err, url: url)
                    NotificationCenter.default.post(name: TTNotifyName.Kit.imageRequestError, object: errInfo)
                    
                    completion(.failure(error: TTError(code: error.errorCode, desc: error.localizedDescription)))
                }
            }
        }
        #endif
    }
}
