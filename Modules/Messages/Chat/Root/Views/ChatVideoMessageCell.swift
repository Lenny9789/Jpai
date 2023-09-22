
import UIKit

class ChatVideoMessageCell: ChatMessageCell {

    /// 视频缩略图
    lazy var thumbImageView: UIImageView = {
        let view = UIImageView()
        
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .black
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    /// 播放按钮
    lazy var playImageView: UIImageView = {
        let view = UIImageView(image: UIImage(color: .random, size: CGSize(width: 40, height: 40)))
        return view
    }()
    
    /// 视频时长标签
    lazy var durationLab: UILabel = {
        let label = UILabel(
            text: "",
            font: UIFont.fontRegular(fontSize: 12),
            color: .themeColor(ThemeGuide.Colors.theme_title)
        )
        return label
    }()
    
    /// 视频进度标签
    lazy var progressLab: UILabel = {
        let label = UILabel(
            text: "",
            font: UIFont.fontRegular(fontSize: 12),
            color: .themeColor(ThemeGuide.Colors.theme_title),
            align: .center
        )
        label.layer.masksToBounds = true
        label.setLayerCorner(radius: 5)
        label.backgroundColor = ThemeGuide.Colors.translucentBg
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        progressLab.isHidden = true
        
        container.addSubview(thumbImageView)
        container.addSubview(playImageView)
        container.addSubview(durationLab)
        container.addSubview(progressLab)
        
        let tapThumb = UITapGestureRecognizer()
        thumbImageView.isUserInteractionEnabled = true
        thumbImageView.addGestureRecognizer(tapThumb)
        tapThumb.rx.event
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                self.eventDelegate?.cellAction(self, event: .videoTapped)
            }).disposed(by: disposeBag)
        
        let tapPlay = UITapGestureRecognizer()
        playImageView.isUserInteractionEnabled = true
        playImageView.addGestureRecognizer(tapPlay)
        tapPlay.rx.event
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                self.eventDelegate?.cellAction(self, event: .videoTapped)
            }).disposed(by: disposeBag)
    }
    
    override func fillWith(_ data: OIMMessageInfo) {
        super.fillWith(data)
        
        guard let videoElement = data.videoElem else { return }
        
//        DispatchQueue.main.async {
            self.thumbImageView.setImage(
                withURL: URL(string: videoElement.snapshotUrl),
                placeholderImage: nil
            )
//        }
        
        durationLab.text = "\(videoElement.duration)\""
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        thumbImageView.whc_AutoSize(left: 0, top: 0, right: 0, bottom: 0)
        
        thumbImageView.addSubview(playImageView)
        playImageView.whc_Center(0, y: 0)
            .whc_Width(40)
            .whc_Height(40)
        
        thumbImageView.addSubview(durationLab)
        durationLab.whc_Right(10)
            .whc_Bottom(2)
            .whc_WidthAuto()
            .whc_HeightAuto()
        
        if curMessage.isInComing() {
            thumbImageView.setLayerCorner(radius: 10, corners: [.bottomCorners, .rightSideCorners])
        }else {
            thumbImageView.setLayerCorner(radius: 10, corners: [.bottomCorners, .leftSideCorners])
        }
    }
    
    
}
