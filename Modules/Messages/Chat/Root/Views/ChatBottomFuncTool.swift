
import UIKit

class ChatBottomFuncTool: BaseView {

    lazy var imageButton: TTReLayoutButton = {
        let button = TTReLayoutButton(style: .image_Top_Text_Bottom(align: .centering(space: 0)))
        button.setImage(.init(named: "photo"), for: .normal)
        button.setTitle("图片", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .fontMedium(fontSize: 13)
        return button
    }()
    
    lazy var videoButton: TTReLayoutButton = {
        let button = TTReLayoutButton(style: .image_Top_Text_Bottom(align: .centering(space: 0)))
        button.setImage(.init(named: "video"), for: .normal)
        button.setTitle("视频", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .fontMedium(fontSize: 13)
        return button
    }()
    
    lazy var voiceCallButton: TTReLayoutButton = {
        let button = TTReLayoutButton(style: .image_Top_Text_Bottom(align: .centering(space: 0)))
        button.setImage(UIImage(named: "phone.voice"), for: .normal)
        button.setTitle("语音通话", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .fontMedium(fontSize: 10)
        return button
    }()
    
    lazy var videoCallButton: TTReLayoutButton = {
        let button = TTReLayoutButton(style: .image_Top_Text_Bottom(align: .centering(space: 0)))
        button.setImage(.init(named: "phone.video"), for: .normal)
        button.setTitle("视频通话", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .fontMedium(fontSize: 10)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        addSubview(imageButton)
        imageButton.whc_Top(10)
            .whc_Left(20)
            .whc_Width(45)
            .whc_Height(65)
        addSubview(videoButton)
        videoButton.whc_Top(10)
            .whc_Left(86)
            .whc_Width(60)
            .whc_Height(65)
        addSubview(voiceCallButton)
        voiceCallButton.whc_Top(10)
            .whc_Left(166)
            .whc_Width(60)
            .whc_Height(65)
        
        addSubview(videoCallButton)
        videoCallButton.whc_Top(10)
            .whc_Left(236)
            .whc_Width(60)
            .whc_Height(65)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
