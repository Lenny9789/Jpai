import RxSwift
import OpenIMSDK
import UIKit
import AliRTCSdk

class RTCController: UIViewController {

    let disposeBag = DisposeBag()
    
    var rtcEngine: AliRtcEngine!
    
    var rtcData: JSON!
    var recvMessage: OIMMessageInfo!
    
    lazy var buttonAccept: UIButton = {
        let button = UIButton(titleColor: .white, font: .systemFont(ofSize: 15))
        button.setTitle("接听", for: .normal)
        button.setBackgroundImage(UIImage(color: .systemGreen), for: .normal)
        return button
    }()
    lazy var buttonRefuse: UIButton = {
        let button = UIButton(titleColor: .white, font: .systemFont(ofSize: 15))
        button.setTitle("拒绝", for: .normal)
        button.setBackgroundImage(UIImage(color: .systemRed), for: .normal)
        return button
    }()
    lazy var localView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var avatar: UIImageView = {
        let img = UIImageView()
        return img
    }()
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    var isCaller = false
    var remoteJoined = false
    var countTimer: Timer?
    var counter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    private func setupViews() {
        view.backgroundColor = .black
        
        view.addSubview(localView)
        localView.whc_Top(0, true)
            .whc_Right(10, true)
            .whc_Width(120)
            .whc_Height(250)
        
        view.addSubview(buttonAccept)
        buttonAccept.whc_CenterX(50)
            .whc_Bottom(40, true)
            .whc_Width(80)
            .whc_Height(80)
            .setLayerCorner(radius: 40)
        view.addSubview(buttonRefuse)
        buttonRefuse.whc_CenterX(-50)
            .whc_Bottom(40, true)
            .whc_Width(80)
            .whc_Height(80)
            .setLayerCorner(radius: 40)
        
        view.addSubview(timeLabel)
        timeLabel.whc_CenterYEqual(buttonRefuse)
            .whc_CenterX(40)
            .whc_WidthAuto()
            .whc_HeightAuto()
        
        view.bringSubviewToFront(buttonRefuse)
        view.bringSubviewToFront(buttonAccept)
        
        buttonAccept.isHidden = isCaller
    }
    
    private func setupBindings() {
        self.rtcEngine = AliRtcEngine.sharedInstance(self, extras: "")
        self.startPreView()
        buttonAccept.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
            self.joinChannal()
        }.disposed(by: disposeBag)
        
        buttonRefuse.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
            self.refuseAction()
        }.disposed(by: disposeBag)
        
        if isCaller {
            joinChannal()
        }
    }
    
    private func refuseAction() {
        if isCaller {
            rtcEngine.stopPreview()
            rtcEngine.leaveChannel()
            navigationController?.popViewController(animated: true)
            //发送通话状态
            let param: Param = ["type": "hang_upfadf3fadf4561fas4d5", "room": rtcData["room"].stringValue]
            let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
            OIMManager.manager.typingStatusUpdate(rtcData["oppositeUserId"].stringValue, msgTip: str ?? "") { _ in}
            
            if remoteJoined {
                //发送自定义通话消息-->在通话中主叫挂断
                let p: Param = ["type": "call_over",
                                "msg": "[通话时间]: \(String(format: "%02d", counter/60)):\(String(format: "%02d", counter%60))",
                                "room": rtcData["room"].stringValue]
                MessageManager.shared.sendCustomMessage(param: p, recvID: rtcData["oppositeUserId"].stringValue)
            }else {
                //发送自定义通话消息--> 未进入通话主叫挂断
                let p: Param = ["type": "hang_up",
                                "status": 8,
                                "room": rtcData["room"].stringValue]
                MessageManager.shared.sendCustomMessage(param: p, recvID: rtcData["oppositeUserId"].stringValue)
            }
        }else {
            if self.rtcEngine.isInCall() {
                rtcEngine.stopPreview()
                rtcEngine.leaveChannel()
                navigationController?.popViewController(animated: true)
                
            }else {
                let param: Param = ["type": "hang_upfadf3fadf4561fas4d5", "room": rtcData["room"].stringValue]
                let str = try? param.jsonString(using: .utf8, options: .init(rawValue: 0))
                OIMManager.manager.typingStatusUpdate(recvMessage.sendID ?? "", msgTip: str ?? "") { _ in }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func startPreView() {
        let canvas = AliVideoCanvas()
        canvas.renderMode = .auto
        canvas.view = localView
        canvas.mirrorMode = .onlyFrontCameraPreviewEnabled
        self.rtcEngine.setLocalViewConfig(canvas, for: AliRtcVideoTrack.camera)
        self.rtcEngine.startPreview()
    }

    // 加入频道成功 调整UI
    func joinChannelSuccessSetupViews() {
        buttonAccept.isHidden = true
        countTimer?.invalidate()
        countTimer = nil
        counter = 0
        countTimer = Timer.init(timeInterval: 1, repeats: true, block: {[weak self] timer in
            guard let `self` = self else { return }
            self.counter += 1
            
            let str = String(format: "%02d", self.counter%60)
            let str2 = String(format: "%02d", self.counter/60)
            self.timeLabel.text = str2 + ":" + str
        })
        countTimer?.tolerance = 0.2
        RunLoop.current.add(countTimer!, forMode: .default)
        countTimer?.fire()
    }
    func joinChannal() {
        let authInfo = AliRtcAuthInfo()
        authInfo.channelId = rtcData["room"].stringValue
        authInfo.appId = rtcData["appid"].stringValue
        authInfo.nonce = rtcData["nonce"].stringValue
        authInfo.userId = rtcData["userid"].stringValue
        authInfo.token = rtcData["token"].stringValue
        authInfo.timestamp = rtcData["timestamp"].int64Value
        authInfo.gslb = (rtcData["gslb"].arrayObject as? [String]) ?? []
        let userName = rtcData["turn"].dictionaryValue["username"]?.stringValue ?? ""

        self.rtcEngine.joinChannel(authInfo, name: userName) { [weak self] errCode, channal, elapsad in
            guard let `self` = self else { return }
            debugPrint("errcode:\(errCode)", channal, elapsad)
            guard errCode == 0 else {
                TToast.show("加入频道失败！")
                return
            }
            if !self.isCaller {
                self.joinChannelSuccessSetupViews()
            }
        }
    }
}
extension RTCController: AliRtcEngineDelegate {
    
    func onJoinChannelResult(_ result: Int32, channel: String, elapsed: Int32) {
        debugPrint("\(result)", channel, elapsed)
    }
    func onRemoteTrackAvailableNotify(_ uid: String, audioTrack: AliRtcAudioTrack, videoTrack: AliRtcVideoTrack) {
        DispatchQueue.main.async {
            if videoTrack == .camera {
                let canvas = AliVideoCanvas()
                canvas.renderMode = .auto
                canvas.view = self.view
                self.rtcEngine.setRemoteViewConfig(canvas, uid: uid, for: .camera)
                
                self.view.bringSubviewToFront(self.localView)
                self.view.bringSubviewToFront(self.buttonRefuse)
                self.view.bringSubviewToFront(self.timeLabel)
            }
        }
    }
    
    //远端用户接听回调
    func onRemoteUser(onLineNotify uid: String, elapsed: Int32) {
        debugPrint(uid)
        if self.isCaller {
            remoteJoined = true
            self.joinChannelSuccessSetupViews()
        }
    }
    
    //远端用户挂掉
    func onRemoteUserOffLineNotify(_ uid: String, offlineReason reason: AliRtcUserOfflineReason) {
        debugPrint(uid, reason)
        rtcEngine.stopPreview()
        rtcEngine.leaveChannel()
        rtcEngine = nil
        
        navigationController?.popViewController(animated: true)
        
        if isCaller {
            //发送自定义通话消息-->在通话中挂断
            let p: Param = ["type": "call_over",
                            "msg": "[通话时间]: \(String(format: "%02d", counter/60)):\(String(format: "%02d", counter%60))",
                            "room": rtcData["room"].stringValue]
            MessageManager.shared.sendCustomMessage(param: p, recvID: rtcData["oppositeUserId"].stringValue)
        }
    }
}
