
import UIKit

class ChatMessageCell: ChatBaseCell {

    /// 头像视图
    lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    /// 昵称标签
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    /// 容器视图
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// 重发视图
    lazy var retryView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(color: .random)
        return view
    }()
    
    /// 活动指示器
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.theme_activityIndicatorViewStyle = ThemeGuide.Colors.theme_indicatorStyle
        view.hidesWhenStopped = true
        return view
    }()
    
    /// 时间 或 消息已读控件
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(container)
//        contentView.addSubview(retryView)
//        contentView.addSubview(indicator)
//        contentView.addSubview(timeLabel)
        
        // 图像点击
        let tapAvatar = UITapGestureRecognizer()
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(tapAvatar)
        tapAvatar.rx.event
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                self.eventDelegate?.cellAction(self, event: .avatarTapped)
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var curMessage: OIMMessageInfo!
    
    func fillWith(_ data: OIMMessageInfo) {
        curMessage = data
        
        avatarView.setImage(
            withURL: URL(string: data.senderFaceUrl),
            placeholderImage: UIImage(.systemBlue, content: data.senderNickname ?? "", width: 40)
        )
        
        nameLabel.text = data.senderNickname
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarView.whc_ResetConstraints()
        nameLabel.whc_ResetConstraints()
        container.whc_ResetConstraints()
        
        if curMessage.isInComing() {
            avatarView.whc_Left(0)
                .whc_Top(0)
                .whc_Width(40)
                .whc_Height(40)
                .setLayerCorner(radius: 5)
            
            nameLabel.whc_Top(0)
                .whc_Left(10, toView: avatarView)
                .whc_WidthAuto()
                .whc_Height(15)
            
            container.whc_Top(5, toView: nameLabel)
                .whc_Left(10, toView: avatarView)
                .whc_Width(curMessage.containerSize().width)
                .whc_Height(curMessage.containerSize().height)
        } else {
            avatarView.whc_Right(0)
                .whc_Top(0)
                .whc_Width(40)
                .whc_Height(40)
                .setLayerCorner(radius: 5)
            
            nameLabel.whc_Top(0)
                .whc_Right(10, toView: avatarView)
                .whc_WidthAuto()
                .whc_Height(15)
            
            container.whc_Top(5, toView: nameLabel)
                .whc_Right(10, toView: avatarView)
                .whc_Width(curMessage.containerSize().width)
                .whc_Height(curMessage.containerSize().height)
        }
    }

}
