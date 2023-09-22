import UIKit
import AVFAudio
import RxSwift
import AudioKit


class TRecorderManager: NSObject {
    
    enum RecorderStartResult {
        case success
        case fail
    }
    
    enum RecorderFinishResult {
        case success(path: String, fileName: String, duration: Int)
        case fail
    }
    
    static let shared = TRecorderManager()

    /// 控制外部录音按钮是否可响应
    var rx_recorderButtonEnabled = PublishSubject<Bool>()
    var isHolding: Bool = false

    var recorderView: TRecorderView!
    var recorderEngine: AVAudioRecorder!
    var recorderTimer: Timer!
    var recorderTotalTime: Int = 0

    var fileName = tt_compactUUID
    var orgFileNamePlusExtension: String {
        return fileName + ".m4a"
    }
    var cvtFileNamePlusExtension: String {
        return fileName + ".mp4"
    }
    
    /// 开始录音
    func startRecorder(controller: UIViewController?,  completionHandler: @escaping(RecorderStartResult) -> Void) {
        isHolding = true
        
        AVAudioSession.sharedInstance().requestRecordPermission { isPermission in
            if isPermission {
                if self.isHolding { //解决首次操作弹出对话框，长按中断时的bug
                    DispatchQueue.main.async {
                        if self.recorderView == nil {
                            self.recorderView = TRecorderView(frame: CGRect(x: (kScreenWidth - 160) / 2, y: (kScreenHeight - 140) / 2, width: 160, height: 140))
                            UIApplication.shared.firstKeyWindow!.addSubview(self.recorderView)
                        }
                    }
                    
                    let ret = self.setupRecorder()
                    if ret {
                        completionHandler(.success)
                    } else {
                        completionHandler(.fail)
                    }
                } else {
                    completionHandler(.fail)
                }
            } else {
                self.showAlter(with: .localized_unauthorizedMicro, controller: controller)
                completionHandler(.fail)
            }
        }
    }
    
    /// 完成录音
    func finishRecorder(completionHandler: @escaping(RecorderFinishResult) -> Void) {
        isHolding = false

        if recorderEngine != nil {
            if recorderEngine.currentTime < 1.0 {
                rx_recorderButtonEnabled.onNext(false)
                
                if recorderView != nil {
                    recorderView.showShotTimeView()
                }

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    self.stopRecorder()
                    
                    completionHandler(.fail)
                }
            } else {
                recorderTotalTime = Int(recorderEngine.currentTime)
                
                stopRecorder()
                
                /// 格式转换
                convertM4AToMP4 { [weak self] result in
                    guard let `self` = self else { return }
                    switch result {
                    case .success(let value):
                        debugPrint("录音文件转换成功：\(value.0)")
                        completionHandler(.success(path: value.0, fileName: value.1, duration: self.recorderTotalTime))
                    case .failure(let error):
                        debugPrint("录音文件转换失败：\(error.localizedDescription)")
                    }
                }
            }
        } else {
            completionHandler(.fail)
        }
    }
    
    /// 取消录音
    func cancelRecorder() {
        isHolding = false

        if recorderEngine != nil {
            stopRecorder()
        }
    }
    
    /// 准备取消
    func readyToCancelRecorder() {
        isHolding = false
        
        if recorderView != nil {
            recorderView.readyToCancelRecorder()
        }
    }
    
    /// 准备恢复
    func readyToResumeRecorder() {
        if recorderView != nil {
            recorderView.readyToResumeRecorder()
        }
    }
    
    /// 停止录音
    func stopRecorder() {
        rx_recorderButtonEnabled.onNext(true)
        
        if recorderTimer != nil {
            recorderTimer.invalidate()
            recorderTimer = nil
        }
        
        if recorderView != nil {
            recorderView.removeFromSuperview()
            recorderView = nil
        }
        
        if recorderEngine != nil {
            recorderEngine.stop()
        }
    }
    
    // MARK: - 授权失败弹框
    private func showAlter(with message: String, controller: UIViewController?) -> Void
    {
        let alertController = UIAlertController(title: .localized_hint, message: message, preferredStyle: UIAlertController.Style.alert)
        let confirmAction = UIAlertAction(title: .localized_sure, style: UIAlertAction.Style.default) { action in
            guard let URL = URL(string: "App-Prefs:root=Privacy") else {
                return
            }
            UIApplication.shared.open(URL, options: [:], completionHandler: { completed in
                
            })
        }
        
        let cancelAction = UIAlertAction(title: .localized_cancel, style: UIAlertAction.Style.cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        controller?.present(alertController, animated: true) {
            
        }
    }
    
    private func setupRecorder() -> Bool
    {
        guard let recorderUrl = try? LocalStorageContext.shared.fileURL(
            place: .documents,
            module: .media,
            file: .custom(orgFileNamePlusExtension)) else {
                return false
            }
        
        debugPrint("录音原始文件：\(recorderUrl)")

        //初始化录音器
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        //设置录音类型
        try? session.setCategory(AVAudioSession.Category.playAndRecord)
        
        //设置支持后台
        try? session.setActive(true)
        
        //初始化字典并添加设置参数
        let recorderSeetingsDic = [
            AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: 1, //录音的声道数，立体声为双声道
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            //AVEncoderBitRateKey : 320000,
            AVSampleRateKey : 44100.0, //录音器每秒采集的录音样本数
            AVLinearPCMIsFloatKey : true //是否使用浮点数采样，如果不是MP3需要用Lame转码为mp3的一定记得设置NO！（不然转码后的声音一直都是杂音）
        ] as [String : Any]
        
        //初始化录音器
        if let recorder = try? AVAudioRecorder(url: recorderUrl, settings: recorderSeetingsDic) {
            recorderEngine = recorder
            //开启仪表计数功能
            recorderEngine.isMeteringEnabled = true
            //准备录音
            recorderEngine.prepareToRecord()
            //开始录音
            recorderEngine.record()
            
            recorderEngine.delegate = self
            
            //启动定时器，定时更新录音音量
            recorderTimer = Timer.scheduledTimer(timeInterval: 0.01,
                                                 target: self,
                                                 selector: #selector(recorderTimerAction),
                                                 userInfo: nil,
                                                 repeats: true)
            return true
        } else {
            return false
        }
    }
    
    /// 将m4a音频导出为mp4格式
    /// @return: (全路径，文件名)
//    public func convertM4AToMP4(completion: @escaping (TTGenericResult<(String, String)>) -> Void) {
//        let audioFile : AKAudioFile
//        do {
//            audioFile = try AKAudioFile(
//                readFileName: LocalStorageContext.shared
//                    .trailingPath(
//                        module: .media,
//                        file: .custom(orgFileNamePlusExtension)
//                    ),
//                baseDir: .documents
//            )
//        } catch let error as NSError {
//            mainQueueExecuting {
//                completion(.failure(error: TTError(code: error.code, desc: error.localizedDescription, userInfo: nil)))
//            }
//            return
//        }
//        func callback(processedFile: AKAudioFile?, error: NSError?) {
//            if let converted = processedFile {
//                mainQueueExecuting { [weak self] in
//                    guard let `self` = self,
//                          let srcUrl = try? LocalStorageContext.shared
//                            .fileURL(place: .documents,
//                                     module: .media,
//                                     file: .custom(self.cvtFileNamePlusExtension)
//                            ),
//                          let dstUrl = try? LocalStorageContext.shared
//                            .fileURL(place: .systemCaches,
//                                     module: .media,
//                                     file: .custom(self.cvtFileNamePlusExtension)
//                            ) else {
//                              let error: TTError = TTError(code: .invalidOperate, desc: .localized_dirCreationFailed)
//                              completion(.failure(error: error))
//                              return
//                          }
//                    do {
//                        // 移动文件
//                        try LocalStorageContext.shared.moveFile(atPath: srcUrl,
//                                                                toPath: dstUrl)
//                        completion(.success(value: (dstUrl.path, converted.fileNamePlusExtension)))
//                    } catch {
//                        let error: TTError = TTError(code: .invalidOperate, desc: .localized_fileMoveFailed)
//                        completion(.failure(error: error))
//                    }
//                }
//            } else {
//                if let error = error {
//                    mainQueueExecuting {
//                        completion(.failure(error: error as! TTError))
//                    }
//                }
//            }
//        }
        
        // 格式转换
//        audioFile.exportAsynchronously(
//            name: LocalStorageContext.shared
//                .trailingPath(
//                    module: .media,
//                    file: .custom(cvtFileNamePlusExtension)
//                ),
//            baseDir: .documents,
//            exportFormat: .mp4,
//            callback: callback
//        )
//    }
    
    @objc func recorderTimerAction() {
        if recorderEngine != nil {
            recorderEngine!.updateMeters() // 刷新音量数据
            var averageV: Float = recorderEngine!.averagePower(forChannel: 0) //获取音量的平均值
            //debugPrint("声波:\(averageV)")
            averageV = averageV + 75.0
            
            if recorderView != nil {
                recorderView.updateAnimationView(averageV: averageV)
            }
        }
    }
}

// MARK: - AVAudioRecorderDelegate
extension TRecorderManager: AVAudioRecorderDelegate
{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        debugPrint("finish recorder \(self)")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?)
    {
    }
}


// MARK: - TRecorderView

class TRecorderView: UIView {
    
    lazy var recordingMicroImageView: UIImageView = {
        let view = UIImageView()
//        view.image = ThemeGuide.Icons.Chat.chatroom_recorder_micro
        return view
    }()
    
    lazy var recordingAnimationImageView: UIImageView = {
        let view = UIImageView()
//        view.image = ThemeGuide.Icons.Chat.chatroom_recorder_vol_5
        return view
    }()
    
    lazy var recordHintTextLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.fontRegular(fontSize: 14)
        label.text = .localized_swipeUpCancel
        return label
    }()
    
    lazy var recordCancelImageView: UIImageView = {
        let view = UIImageView()
//        view.image = ThemeGuide.Icons.Chat.chatroom_recorder_cancel
        return view
    }()
    
    lazy var recordShotTimeImageView: UIImageView = {
        let view = UIImageView()
//        view.image = ThemeGuide.Icons.Chat.chatroom_recorder_shot_time
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        theme_backgroundColor = ThemeGuide.Colors.theme_foreground
        setLayerShadow(radius: 15)
        
        addSubview(recordingMicroImageView)
        addSubview(recordingAnimationImageView)
        addSubview(recordHintTextLabel)
        addSubview(recordCancelImageView)
        addSubview(recordShotTimeImageView)
        recordingMicroImageView.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.top.equalTo(25)
            make.width.equalTo(37)
            make.height.equalTo(70)
        }
        recordingAnimationImageView.snp.makeConstraints { (make) in
            make.left.equalTo(recordingMicroImageView.snp.right).offset(16)
            make.top.equalTo(30)
            make.width.equalTo(29)
            make.height.equalTo(64)
        }
        recordHintTextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(recordingAnimationImageView.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        recordCancelImageView.snp.makeConstraints { (make) in
            make.left.equalTo(45)
            make.top.equalTo(20)
            make.width.equalTo(60)
            make.height.equalTo(75)
        }
        recordShotTimeImageView.snp.makeConstraints { (make) in
            make.left.equalTo(70)
            make.top.equalTo(20)
            make.width.equalTo(20)
            make.height.equalTo(75)
        }
        
        recordingMicroImageView.isHidden     = false
        recordingAnimationImageView.isHidden = false
        recordCancelImageView.isHidden       = true
        recordShotTimeImageView.isHidden     = true
    }
    
    func updateAnimationView(averageV: Float) {
        if averageV > 0.0 && averageV <= 10.0 {
//            self.recordingAnimationImageView.image = ThemeGuide.Icons.Chat.chatroom_recorder_vol_1
        } else if averageV > 10.0 && averageV <= 20.0 {
//            self.recordingAnimationImageView.image = ThemeGuide.Icons.Chat.chatroom_recorder_vol_2
        } else if averageV > 20.0 && averageV <= 30.0 {
//            self.recordingAnimationImageView.image = ThemeGuide.Icons.Chat.chatroom_recorder_vol_3
        } else if averageV > 30.0 && averageV <= 40.0 {
//            self.recordingAnimationImageView.image = ThemeGuide.Icons.Chat.chatroom_recorder_vol_4
        } else if averageV > 40.0 && averageV <= 50.0 {
//            self.recordingAnimationImageView.image = ThemeGuide.Icons.Chat.chatroom_recorder_vol_5
        } else if averageV > 50.0 && averageV <= 60.0 {
//            self.recordingAnimationImageView.image = ThemeGuide.Icons.Chat.chatroom_recorder_vol_6
        } else if averageV > 60.0 && averageV <= 70.0 {
//            self.recordingAnimationImageView.image = ThemeGuide.Icons.Chat.chatroom_recorder_vol_7
        } else{
//            self.recordingAnimationImageView.image = ThemeGuide.Icons.Chat.chatroom_recorder_vol_7
        }
    }
    
    func readyToCancelRecorder() {
        recordingMicroImageView.isHidden     = true
        recordingAnimationImageView.isHidden = true
        recordCancelImageView.isHidden       = false
        recordShotTimeImageView.isHidden     = true
        recordHintTextLabel.text = .localized_releaseFingerCancel
    }
    
    func readyToResumeRecorder() {
        recordingMicroImageView.isHidden     = false
        recordingAnimationImageView.isHidden = false
        recordCancelImageView.isHidden       = true
        recordShotTimeImageView.isHidden     = true
        recordHintTextLabel.text = .localized_swipeUpCancel
    }
    
    func showShotTimeView() {
        recordingMicroImageView.isHidden     = true
        recordingAnimationImageView.isHidden = true
        recordCancelImageView.isHidden       = true
        recordShotTimeImageView.isHidden     = false
        recordHintTextLabel.text             = .localized_timeTooShort
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
