import UIKit
import AVFoundation
import CommonCrypto

/// 获取文件大小（Byte）
public func tt_fileSizeByte(_ fileUrl: URL) -> Int
{
    guard FileManager.default.fileExists(atPath: fileUrl.path) else {
        return 0
    }
    
    var fileSize : Int = 0
    do {
        let attr = try FileManager.default.attributesOfItem(atPath: fileUrl.path)
        fileSize = attr[FileAttributeKey.size] as! Int
         
        let dict = attr as NSDictionary
        fileSize = Int(dict.fileSize())
    } catch {
        debugPrint("Error: \(error)")
    }
     
    return fileSize
}

/// 获取文件大小（M）
public func tt_fileSizeMB(_ fileUrl: URL) -> CGFloat {
    if let fileDictionary = try? FileManager.default.attributesOfItem(atPath: fileUrl.path) {
        let fileSize = fileDictionary[FileAttributeKey.size]
        return fileSize as! CGFloat / 1024.0 / 1024.0
    } else {
        return 0
    }
}

/// 获取文件大小（M）
public func tt_showFileSizeMB(_ fileUrl: URL) -> String {
    if let fileDictionary = try? FileManager.default.attributesOfItem(atPath: fileUrl.path) {
        let fileSize = fileDictionary[FileAttributeKey.size]
        let size = fileSize as! CGFloat
        if size < 1024 {
            return String(format: "%.1fB", size)
        } else if size < 1024*1024 {
            return String(format: "%.1fKB", size/1024)
        } else if size < 1024*1024*1024 {
            return String(format: "%.1fMB", size/(1024*1024))
        } else {
            return String(format: "%.1fGB", size/(1024*1024*1024))
        }
    } else {
        return ""
    }
}

/// 获取视频预览图
public func tt_videoCropPicture(videoUrl: URL) -> UIImage? {
    let avAsset = AVURLAsset(url: videoUrl)
    let generator = AVAssetImageGenerator(asset: avAsset)
    generator.appliesPreferredTrackTransform = true
    let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
    var actualTime: CMTime = CMTimeMake(value: 0, timescale: 0)
    if let imageP = try? generator.copyCGImage(at: time, actualTime: &actualTime) {
        return UIImage(cgImage: imageP)
    }
    return nil
}

/// 获取文件MD5值
public func tt_fileMD5Hash(file: FilePayload) -> String? {
    let bufferSize = 1024 * 1024
    do {
        //初始化内容
        var context = CC_MD5_CTX()
        CC_MD5_Init(&context)
        
        switch file {
        case .data(let data):
            data.withUnsafeBytes {
                _ = CC_MD5_Update(&context, $0, CC_LONG(data.count))
            }
            
        case .url(let url):
            //打开文件
            let fileHandle = try FileHandle(forReadingFrom: url)
            defer {
                fileHandle.closeFile()
            }
            
            //读取文件信息
            while case let data = fileHandle.readData(ofLength: bufferSize), data.count > 0 {
                data.withUnsafeBytes {
                    _ = CC_MD5_Update(&context, $0, CC_LONG(data.count))
                }
            }
        }
        
        //计算Md5摘要
        var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        digest.withUnsafeMutableBytes {
            _ = CC_MD5_Final($0, &context)
        }
        
        return digest.map { String(format: "%02hhx", $0) }.joined()
    } catch {
        print("Cannot open file:", error.localizedDescription)
        return nil
    }
}
