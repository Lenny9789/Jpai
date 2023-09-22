
import UIKit

class ChatVoiceMesssageCell: ChatBubbleCell {

    /// 语音图标
    lazy var voiceImageView: UIImageView = {
        let view = UIImageView()
        view.animationDuration = 1
        return view
    }()
    
    /// 语音时长标签
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.theme_textColor = ThemeGuide.Colors.theme_title
//        label.textAlignment = .center
        return label
    }()
    
    /// 未播放提醒提示
    lazy var voiceReadPointView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .red
        return view
    }()
    
    func updateVoiceAnimate(_ animate: Bool) -> Void {
        if animate {
            voiceImageView.startAnimating()
        } else {
            voiceImageView.stopAnimating()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bubbleView.addSubview(voiceImageView)
        bubbleView.addSubview(durationLabel)
        bubbleView.addSubview(voiceReadPointView)
        
        voiceReadPointView.setLayerCorner(radius: 4)
        voiceReadPointView.isHidden = true
        
        
        
        let tapThumb = UITapGestureRecognizer()
        bubbleView.isUserInteractionEnabled = true
        bubbleView.addGestureRecognizer(tapThumb)
        tapThumb.rx.event
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                self.eventDelegate?.cellAction(self, event: .voiceTapped)
            }).disposed(by: disposeBag)
    }
    
    override func fillWith(_ data: OIMMessageInfo) {
        super.fillWith(data)

        /// 图标
        if data.isInComing() {
            voiceImageView.image = R.image.chatroom_msg_receiver_voice()
            let images = [R.image.chatroom_msg_receiver_voice_play_1()!,
                         R.image.chatroom_msg_receiver_voice_play_2()!,
                         R.image.chatroom_msg_receiver_voice_play_3()!]
            voiceImageView.animationImages = images
        } else {
            voiceImageView.image = R.image.chatroom_msg_sender_voice()
            let images = [R.image.chatroom_msg_sender_voice_play_1()!,
                          R.image.chatroom_msg_sender_voice_play_2()!,
                          R.image.chatroom_msg_sender_voice_play_3()!]
            voiceImageView.animationImages = images
        }
        
        
        if let duration = data.soundElem?.duration, duration > 0 {
            durationLabel.text = "\(duration)\"";
        } else {
            durationLabel.text = "1\"" // 显示0秒容易产生误解
        }

        /// 未播放提醒标志
//        if !data.isPlayed && data.direction == .MsgDirectionIncoming {
//            voiceReadPointView.isHidden = false
//        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// 图片
        voiceImageView.sizeToFit()
        
        if curMessage.isInComing() {
            durationLabel.whc_CenterY(0)
                .whc_Left(10)
                .whc_WidthAuto()
                .whc_HeightAuto()
            voiceImageView.whc_CenterY(0)
                .whc_Left(10, toView: durationLabel)
            
        } else {
            durationLabel.whc_CenterY(0)
                .whc_Right(10)
                .whc_WidthAuto()
                .whc_HeightAuto()
            voiceImageView.whc_CenterY(0)
                .whc_Right(10, toView: durationLabel)
            
        }
//        if voiceData.direction == .MsgDirectionIncoming {
//            voiceImageView.x = voiceData.cellLayout.bubbleInsets!.left
//        } else {
//            voiceImageView.right = bubbleView.right - voiceData.cellLayout.bubbleInsets!.right
//        }
//
//        /// 时长
//        let durationSize = kSingleLineTextSize(text: durationLabel.text!, font: voiceData.durationFont!)
//        durationLabel.width = durationSize.width
//        durationLabel.height = durationSize.height
//        durationLabel.centerY = voiceImageView.centerY
//        if voiceData.direction == .MsgDirectionIncoming {
//            durationLabel.x = voiceImageView.right + 5
//        } else {
//            durationLabel.right = voiceImageView.x - 5
//        }
//
//        /// 未播放标识
//        voiceReadPointView.width = 8
//        voiceReadPointView.height = 8
//        voiceReadPointView.y = bubbleView.y
//        if voiceData.direction == .MsgDirectionIncoming {
//            voiceReadPointView.x = bubbleView.right + 2
//        } else {
//            voiceReadPointView.right = bubbleView.x - 2
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
