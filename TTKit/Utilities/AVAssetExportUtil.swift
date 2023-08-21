import Foundation
import Photos

/// 将MOV视频导出为mp4格式
public func tt_convertMovToMp4(fileURL: URL, completion: @escaping (URL?) -> Void) {
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
    debugPrint("newUrl: \(newUrl)")
    
    let avAsset = AVURLAsset(url: fileURL, options: nil)
    let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)!
    exportSession.outputURL = newUrl
    exportSession.outputFileType = AVFileType.mp4
    exportSession.shouldOptimizeForNetworkUse = false

    exportSession.exportAsynchronously {
        switch exportSession.status {
        case .failed:
            debugPrint("导出状态: 失败")
            completion(nil)
            break

        case .cancelled:
            debugPrint("导出状态: 取消")
            completion(nil)
            break

        case .completed:
            debugPrint("导出状态: 完成")
            completion(newUrl)

        default:
            completion(nil)
            break
        }
    }
}


/// 将MOV视频导出为mp4格式
public func tt_startExportMP4VideoWithVideoAsset(videoAsset: AVURLAsset,
                                                 presetName: String,
                                                 completion: @escaping (TTGenericResult<String>) -> Void) {
    let composition = AVMutableComposition()
    
    guard let compositionVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
        completion(.failure(error: TTError(code: .generalError, desc: "系统错误")))
        return;
    }
    guard let compositionAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
        completion(.failure(error: TTError(code: .generalError, desc: "系统错误")))
        return;
    }
    guard let sourceVideoTrack = videoAsset.tracks(withMediaType: .video).first else {
        completion(.failure(error: TTError(code: .generalError, desc: "系统错误")))
        return;
    }
    guard let sourceAudioTrack = videoAsset.tracks(withMediaType: .audio).first else {
        completion(.failure(error: TTError(code: .generalError, desc: "系统错误")))
        return;
    }
    
    try? compositionVideoTrack.insertTimeRange(CMTimeRangeMake(start: .zero, duration: videoAsset.duration), of: sourceVideoTrack, at: .zero)
    try? compositionAudioTrack.insertTimeRange(CMTimeRangeMake(start: .zero, duration: videoAsset.duration), of: sourceAudioTrack, at: .zero)

    let presets = AVAssetExportSession.exportPresets(compatibleWith: composition)
    guard presets.contains(presetName) else {
        let errMsg = "当前设备不支持该预设: \(presetName)"
        debugPrint(errMsg)
        completion(.failure(error: TTError(code: .generalError, desc: errMsg)))
        return;
    }
    
    guard let session = AVAssetExportSession(asset: composition, presetName: presetName) else {
        completion(.failure(error: TTError(code: .generalError, desc: "系统错误")))
        return;
    }
    
    // 输出地址
    let tempPath = NSTemporaryDirectory()
    let formater = Date().string(format: "yyyy-MM-dd-HH:mm:ss-SSS")
    let outputPath = "\(tempPath)/video-\(formater).mp4"
    if FileManager.default.fileExists(atPath: outputPath) {
        try? FileManager.default.removeItem(atPath: outputPath)
    }
    session.outputURL = URL(fileURLWithPath: outputPath)
    // 优化
    session.shouldOptimizeForNetworkUse = true
    
    let supportedTypeArray = session.supportedFileTypes
    if supportedTypeArray.contains(AVFileType.mp4) {
        session.outputFileType = AVFileType.mp4
    } else if supportedTypeArray.count == 0 {
        debugPrint("No supported file types 视频类型暂不支持导")
        completion(.failure(error: TTError(code: .generalError, desc: "该视频类型暂不支持导出")))
        return
    } else {
        session.outputFileType = supportedTypeArray.first;
    }
    
    let videoComposition = fixedCompositionWithAsset(videoAsset: composition, degrees: degressFromVideoFileWithAsset(asset: videoAsset))
    if videoComposition.renderSize.width > 0 {
        // 修正视频转向
        session.videoComposition = videoComposition
    }
    
    session.exportAsynchronously(completionHandler: {
        mainQueueExecuting {
            switch session.status {
            case .unknown:
                debugPrint("导出状态: 未知")
            case .waiting:
                debugPrint("导出状态: 等待中")
            case .exporting:
                debugPrint("导出状态: 导出中")
            case .completed:
                debugPrint("导出状态: 完成")
                completion(.success(value: outputPath))
            case .failed:
                debugPrint("导出状态: 失败")
                completion(.failure(error: TTError(code: .generalError, desc: "视频导出失败")))
            case .cancelled:
                debugPrint("导出状态: 取消")
                completion(.failure(error: TTError(code: .generalError, desc: "导出任务已被取消")))
            default:
                break
            }
        }
    })
}

/// 获取优化后的视频转向信息
public func fixedCompositionWithAsset(videoAsset: AVAsset, degrees: Int) -> AVMutableVideoComposition {
    let videoComposition = AVMutableVideoComposition()
    guard degrees != 0 else {
        return videoComposition
    }
    
    var translateToCenter: CGAffineTransform
    var mixedTransform: CGAffineTransform
    videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30);
    
    let tracks = videoAsset.tracks(withMediaType: .video)
    guard let videoTrack = tracks.first else {
        return videoComposition
    }
    
    let roateInstruction = AVMutableVideoCompositionInstruction()
    roateInstruction.timeRange = CMTimeRangeMake(start: .zero, duration: videoAsset.duration)
    let roateLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
    
    if degrees == 90 {
        // 顺时针旋转90°
        translateToCenter = CGAffineTransform(translationX: videoTrack.naturalSize.height, y: 0.0)
        mixedTransform = translateToCenter.rotated(by: CGFloat(Double.pi/2))
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.width)
        roateLayerInstruction.setTransform(mixedTransform, at: .zero)
    } else if degrees == 180 {
        // 顺时针旋转180°
        translateToCenter = CGAffineTransform(translationX: videoTrack.naturalSize.width, y: videoTrack.naturalSize.height)
        mixedTransform = translateToCenter.rotated(by: CGFloat(Double.pi))
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.width, height: videoTrack.naturalSize.height)
        roateLayerInstruction.setTransform(mixedTransform, at: .zero)
    } else if degrees == 270 {
        // 顺时针旋转270°
        translateToCenter = CGAffineTransform(translationX: 0.0, y: videoTrack.naturalSize.width)
        mixedTransform = translateToCenter.rotated(by: CGFloat((Double.pi/2)*3.0))
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.width)
        roateLayerInstruction.setTransform(mixedTransform, at: .zero)
    }
    
    roateInstruction.layerInstructions = [roateLayerInstruction]
    // 加入视频方向信息
    videoComposition.instructions = [roateInstruction]
    
    return videoComposition
}

/// 获取视频角度
public func degressFromVideoFileWithAsset(asset: AVAsset) -> Int {
    var degress: Int = 0
    let tracks = asset.tracks(withMediaType: .video)
    guard tracks.count > 0, let videoTrack = tracks.first else {
        return degress
    }
    
    let t = videoTrack.preferredTransform
    if t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0 {
        // Portrait
        degress = 90
    } else if t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0 {
        // PortraitUpsideDown
        degress = 270
    } else if t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0 {
        // LandscapeRight
        degress = 0
    } else if t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0 {
        // LandscapeLeft
        degress = 180
    }
    
    return degress
}


/// 压缩视频
public func tt_compressVideo(fileURL: URL, outputURL:URL, completion: @escaping (URL?) -> Void) {
    let asset = AVAsset(url: fileURL)
    var readerError: Error?
    var reader: AVAssetReader? = nil
    do {
        reader = try AVAssetReader(asset: asset)
    } catch let error {
        readerError = error
    }
    if readerError != nil {
        debugPrint("reader初始化失败")
        completion(nil)
        return
    }
    var writerError: Error?
    var writer: AVAssetWriter? = nil
    do {
        writer = try AVAssetWriter(url: outputURL, fileType: .mp4)
    } catch let error {
        writerError = error
    }
    if writerError != nil {
        debugPrint("writer初始化失败")
        completion(nil)
        return
    }
    let videoTrack = asset.tracks(withMediaType: .video).first
    var videoOutput: AVAssetReaderTrackOutput? = nil
    if let videoTrack = videoTrack {
        videoOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: nil)
    }
    if let videoOutput = videoOutput {
        if reader!.canAdd(videoOutput) {
            reader!.add(videoOutput)
        }
    }
    let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoCompressSettings)
    if writer!.canAdd(videoInput) {
        writer!.add(videoInput)
    }
    
    let audioTrack = asset.tracks(withMediaType: .audio).first
    var audioOutput: AVAssetReaderTrackOutput? = nil
    if let audioTrack = audioTrack {
        audioOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: nil)
    }
    if let audioOutput = audioOutput {
        if reader!.canAdd(audioOutput) {
            reader!.add(audioOutput)
        }
    }
    let audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioCompressSettings)
    if writer!.canAdd(audioInput) {
        writer!.add(audioInput)
    }

    reader!.startReading()
    writer!.startWriting()
    writer!.startSession(atSourceTime: .zero)
    
    let group = DispatchGroup()
    let inputQueue = DispatchQueue(label: "EncoderInputQueue")
    group.enter()
    videoInput.requestMediaDataWhenReady(on: inputQueue, using: {
        while videoInput.isReadyForMoreMediaData {
            if reader!.status == .reading{
                if let sampleBuffer: CMSampleBuffer = videoOutput!.copyNextSampleBuffer() {
                    let result = videoInput.append(sampleBuffer)
                    if !result {
                        reader!.cancelReading()
                        break
                    }
                }
            } else {
                videoInput.markAsFinished()
                group.leave()
                break
            }
        }
    })
    
    group.enter()
    audioInput.requestMediaDataWhenReady(on: inputQueue, using: {
        while audioInput.isReadyForMoreMediaData {
            if reader!.status == .reading{
                if let sampleBuffer: CMSampleBuffer = audioOutput!.copyNextSampleBuffer() {
                    let result = audioInput.append(sampleBuffer)
                    if !result {
                        reader!.cancelReading()
                        break
                    }
                }
            } else {
                videoInput.markAsFinished()
                group.leave()
                break
            }
        }
    })
    
    group.notify(queue: inputQueue){
        if reader!.status == .reading {
            reader!.cancelReading()
        }
        switch writer!.status {
        case AVAssetWriter.Status.writing:
            writer!.finishWriting(completionHandler: {
                debugPrint(String(format: "size of compressed video at %@ is %0.2f M", outputURL.path, tt_fileSizeMB(outputURL)))
            })
            completion(outputURL)
        default:
            debugPrint("导出状态: 失败")
            completion(nil)
            break
        }
    }
}

var videoCompressSettings: [String : Any]? = {
    return [
        AVVideoCodecKey: AVVideoCodecType.h264,
        AVVideoWidthKey: NSNumber(value: 720),
        AVVideoHeightKey: NSNumber(value: 1280),
        AVVideoCompressionPropertiesKey: [
        AVVideoAverageBitRateKey: NSNumber(value: 6000000),
        AVVideoProfileLevelKey: AVVideoProfileLevelH264High40
        ]
    ]
}()

var audioCompressSettings: [String : Any]? = {
    return [
        AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
        AVNumberOfChannelsKey: NSNumber(value: 2),
        AVSampleRateKey: NSNumber(value: 44100),
        AVEncoderBitRateKey: NSNumber(value: 128000)
    ]
}()
