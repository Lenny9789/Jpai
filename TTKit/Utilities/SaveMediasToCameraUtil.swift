import Foundation
import UIKit

public class SaveMediasToCameraUtil: NSObject {
    public static let shared = SaveMediasToCameraUtil()
    
    /// 将Bundle中的一组图片保存到相册
    public func saveBundleImagesToCameraRoll(names: [String]) {
        for name in names {
            let resource = String(name.split(separator: ".").first!)
            let type = String(name.split(separator: ".").last!)
            let file = Bundle.main.path(forResource: resource, ofType: type)!
            let image = UIImage(contentsOfFile: file)!
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageComplete), nil)
        }
    }

    /// 将Bundle中的一组视频保存到相册
    public func saveBundleVideosToCameraRoll(names: [String]) {
        for name in names {
            let resource = String(name.split(separator: ".").first!)
            let type = String(name.split(separator: ".").last!)
            let file = Bundle.main.path(forResource: resource, ofType: type)!
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(file) {
                UISaveVideoAtPathToSavedPhotosAlbum(file, self, #selector(saveVideoComplete), nil)
            } else {
                debugPrint("视频保存失败！")
            }
        }
    }
    
    @objc private func saveImageComplete(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            debugPrint("图片保存失败!")
        } else {
            debugPrint("图片保存成功!")
        }
    }
    
    @objc private func saveVideoComplete(_ videoPath: NSString, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer)
     {
        if let _ = error {
            debugPrint("视频保存失败!")
        }else{
            debugPrint("视频保存成功!")
        }
    }
    
}


