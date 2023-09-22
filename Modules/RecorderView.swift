import UIKit
import AVFAudio
import RxSwift
import RxCocoa

class RecorderView: UIView, AVAudioPlayerDelegate {
    let disposeBag = DisposeBag()
    
    lazy var buttonRecord: UIButton = {
        let button = UIButton()
        button.setTitle("开始", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("停止", for: .selected)
        button.setTitleColor(.black, for: .selected)
        button.setBackgroundImage(UIImage(color: .systemRed), for: .normal)
        button.isEnabled = false
        return button
    }()
    
    lazy var buttonPlay: UIButton = {
        let button = UIButton()
        button.setTitle("播放", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("停止", for: .selected)
        button.setTitleColor(.black, for: .selected)
        button.setBackgroundImage(UIImage(color: .systemRed), for: .normal)
        button.isEnabled = false
        return button
    }()
    
    lazy var buttonSend: UIButton = {
        let button = UIButton()
        button.setTitle("发送", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
//        button.setTitle("停止", for: .selected)
//        button.setTitleColor(.black, for: .selected)
        button.setBackgroundImage(UIImage(color: .systemRed), for: .normal)
        button.isEnabled = false
        return button
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemGreen
        label.text = "00:00"
        return label
    }()
    
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var audioPlayer: AVAudioPlayer!
    
    init() {
        super.init(frame: .zero)
        
        addSubview(buttonSend)
        buttonSend.whc_Right(10)
            .whc_Top(5)
            .whc_Width(60)
            .whc_Height(35)
        addSubview(buttonPlay)
        buttonPlay.whc_Top(5)
            .whc_Right(10, toView: buttonSend)
            .whc_Width(60)
            .whc_Height(35)
        addSubview(buttonRecord)
        buttonRecord.whc_Top(5)
            .whc_Right(10, toView: buttonPlay)
            .whc_Width(60)
            .whc_Height(35)
        
        addSubview(timeLabel)
        timeLabel.whc_CenterYEqual(buttonRecord)
            .whc_Left(10)
            .whc_Width(60)
            .whc_Height(30)
        
        buttonRecord.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
            if self.audioRecorder == nil {
                self.startRecording()
            }else {
                self.finishRecording(success: true)
            }
        }.disposed(by: disposeBag)
        
        buttonPlay.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            guard let url = self.voiceUrl else {
                return
            }
            do {
                try self.recordingSession.setCategory(.playback)
            }catch {
                debugPrint(error)
            }
            self.audioPlayer = try? AVAudioPlayer.init(contentsOf: url)
            self.audioPlayer.play()
            self.audioPlayer.delegate = self
        }.disposed(by: disposeBag)
        
        buttonSend.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            guard let url = self.voiceUrl else {
                return
            }
            self.sendRecordVoice?(url)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchRecordingPermission() {
        // MARK: 配置Session+申请权限
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [weak self] allowed in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    if allowed {
                        // MARK: 打开录制按钮
                        self.buttonRecord.isEnabled = true
                    } else {
                        debugPrint("没有录音权限")
                    }
                }
            }
        } catch {
            debugPrint(error)
        }
    }
    
    var voiceUrl: URL?
    var mainTimer: Timer?
    
    var sendRecordVoice: ( (URL) -> Void)?
}

// MARK: - 录音
extension RecorderView {
    
    private func startRecording() {
        buttonPlay.isEnabled = false
        buttonSend.isEnabled = false
        // MARK: 1-配置录音保存的地址
        let tempPath = NSTemporaryDirectory()
        
        let filePath = "\(tempPath)recording.m4a"
        if FileManager.default.fileExists(atPath: filePath) {
            try? FileManager.default.removeItem(atPath: filePath)
        }
        guard let newUrl = URL(string: "file://\(filePath)") else {
            debugPrint("filepath: \(filePath)")
            return
        }
        debugPrint(newUrl)
        voiceUrl = newUrl
        // MARK: 2-一些配置
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try recordingSession.setCategory(.playAndRecord)
            audioRecorder = try AVAudioRecorder(url: newUrl, settings: settings)
            audioRecorder.record(forDuration: 60 * 2)
            audioRecorder.prepareToRecord()
            audioRecorder.delegate = self
            
            
            mainTimer = Timer.init(timeInterval: 1, repeats: true, block: { timer in
                self.timeLabel.text = self.audioRecorder.currentTime.description
            })
            mainTimer?.tolerance = 0.1
            RunLoop.current.add(mainTimer!, forMode: .default)
            
            // MARK: 3-开始录音
            audioRecorder.record()
            mainTimer?.fire()
            buttonRecord.setTitle("停止", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    // 1-用户按下按钮停止录音和2-录音失败都调用此函数，分别传入true和false
    private func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        mainTimer?.invalidate()
        mainTimer = nil
        if success {// 用户按下按钮停止录音的情况
            buttonRecord.setTitle("成功，继续录音", for: .normal)
            buttonPlay.isEnabled = true
            buttonSend.isEnabled = true
        } else {// 录音失败的情况
            buttonRecord.setTitle("失败，继续录音", for: .normal)
        }
    }
}

// MARK: - AVAudioRecorderDelegate
extension RecorderView: AVAudioRecorderDelegate{
    // 录音意外中断（手机来电等）的时候
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
