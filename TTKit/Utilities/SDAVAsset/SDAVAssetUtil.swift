import Foundation
import UIKit
import Photos

public func tt_fetchVideoSnapshotToTempDir(_ fileURL: URL) -> URL? {
    let opts = [AVURLAssetPreferPreciseDurationAndTimingKey: false]
    let urlAsset = AVURLAsset(url: fileURL, options: opts)
    let generator = AVAssetImageGenerator(asset: urlAsset)
    generator.appliesPreferredTrackTransform = true
    var snapImage: UIImage!
    
    let asset = AVURLAsset(url: fileURL)
    let time = asset.duration
    
    if let img = try? generator.copyCGImage(at: CMTime(value: CMTimeValue(0.01), timescale: time.timescale),
                                            actualTime: nil) {
        snapImage = UIImage(cgImage: img)
    }else if let img = try? generator.copyCGImage(at: CMTime(value: CMTimeValue(0.1),
                                                             timescale: time.timescale),
                                                  actualTime: nil) {
        snapImage = UIImage(cgImage: img)
    }
    
    let tempPath = NSTemporaryDirectory()
    let urlName = fileURL.deletingPathExtension()
    let filePath = "\(tempPath)\(urlName.lastPathComponent.removingPercentEncoding!)temp.jpg)"
    guard let newUrl = URL(string: "file://\(filePath)") else {
        return nil
    }
    if FileManager.default.fileExists(atPath: filePath) {
        try? FileManager.default.removeItem(atPath: filePath)
    }
    do {
        try snapImage.jpeg()?.write(to: newUrl)
        
        return newUrl
    } catch {
        debugPrint("保存文件失败：\(error)")
        return nil
    }
}

public func tt_convtHEICToJPG(fileURL: URL) -> URL? {
    let tempPath = NSTemporaryDirectory()
    let urlName = fileURL.deletingPathExtension()
    let filePath = "\(tempPath)\(urlName.lastPathComponent.removingPercentEncoding!)temp.jpg)"
    guard let newUrl = URL(string: "file://\(filePath)") else {
        return nil
    }
    if FileManager.default.fileExists(atPath: filePath) {
        try? FileManager.default.removeItem(atPath: filePath)
    }
    
    do {
        let image = try UIImage(data: Data(contentsOf: fileURL))
        try image!.jpeg()?.write(to: newUrl)
        
        return newUrl
    } catch {
        debugPrint("保存文件失败：\(error)")
        return nil
    }
}

public func tt_copyFileToTempDir(fileURL: URL) -> URL? {
    let tempPath = NSTemporaryDirectory()
    let urlName = fileURL.deletingPathExtension()
    var filePath = "\(tempPath)\(urlName.lastPathComponent.removingPercentEncoding!).\(fileURL.pathExtension)"
    guard let newUrl = URL(string: "file://\(filePath)") else {
        return nil
    }
    if FileManager.default.fileExists(atPath: filePath) {
        try? FileManager.default.removeItem(atPath: filePath)
    }
    do {
        try FileManager.default.copyItem(at: fileURL, to: newUrl)
        return newUrl
    } catch {
        debugPrint("拷贝文件失败：\(error)")
        return nil
    }
}

public func tt_compressVideo(fileURL: URL, completion: @escaping (URL?) -> Void) {
    let tempPath = NSTemporaryDirectory()
    let urlName = fileURL.deletingPathExtension()
    let filePath = "\(tempPath)\(urlName.lastPathComponent.removingPercentEncoding!).mp4"
    guard let newUrl = URL(string: "file://\(filePath)") else {
        completion(nil)
        return
    }
    if FileManager.default.fileExists(atPath: filePath) {
        try? FileManager.default.removeItem(atPath: filePath)
    }
    debugPrint(String(format: "原大小 %0.2f M", tt_fileSizeMB(fileURL)))
    let asset = AVAsset(url: fileURL)
    let encoder = SDAVAssetExportSession(asset: asset)
    encoder!.outputFileType = AVFileType.mp4 as NSString
    encoder!.outputURL = newUrl
    //视频设置
    encoder!.videoSettings = [
        AVVideoCodecKey: AVVideoCodecType.h264,
        AVVideoWidthKey: NSNumber(value: 720),
        AVVideoHeightKey: NSNumber(value: 1280),
        AVVideoCompressionPropertiesKey: [
        AVVideoAverageBitRateKey: NSNumber(value: 3000000),
        AVVideoProfileLevelKey: AVVideoProfileLevelH264High40]
    ]
    //音频设置
    encoder!.audioSettings = [
        AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
        AVNumberOfChannelsKey: NSNumber(value: 2),
        AVSampleRateKey: NSNumber(value: 44100),
        AVEncoderBitRateKey: NSNumber(value: 128000)
    ]
    encoder!.exportAsynchronously(completionHandler: {
        if encoder!.status == .completed {
            debugPrint("导出状态: 完成")
            debugPrint(String(format: "size of compressed video at %@ is %0.2f M", encoder!.outputURL.path, tt_fileSizeMB(encoder!.outputURL)))
            completion(newUrl)
        } else if encoder!.status == .cancelled {
           debugPrint("导出状态: 取消")
           completion(nil)
        }else {
            debugPrint("导出状态: 失败")
            completion(nil)
        }
    })
}
