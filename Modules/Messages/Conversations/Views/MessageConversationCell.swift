
import UIKit

class MessageConversationCell: UITableViewCell {

    lazy var avatar: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        return img
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .init(white: 0, alpha: 0.8)
        
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray
        
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .cellBackgroundColor
        
        contentView.addSubview(avatar)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(dateLabel)
        
        removeBadge()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatar.whc_Left(16)
            .whc_CenterY(0)
            .whc_Width(40)
            .whc_Height(40)
            .setLayerCorner(radius: 5)
        nameLabel.whc_TopEqual(avatar)
            .whc_Left(10, toView: avatar)
            .whc_WidthAuto()
            .whc_Height(15)
        descLabel.whc_BottomEqual(avatar)
            .whc_Left(10, toView: avatar)
            .whc_Height(15)
        dateLabel.whc_Right(16)
            .whc_TopEqual(nameLabel)
            .whc_WidthAuto()
            .whc_HeightAuto()
    }
    
    private var curModel: OIMConversationInfo!
    
    func present(_ model: OIMConversationInfo) {
        self.curModel = model
        
        nameLabel.text = model.showName
        avatar.setImage(
            withURL: URL(string: model.latestMsg?.senderFaceUrl),
            placeholderImage: UIImage(.systemRed, content: model.showName ?? "", width: 40)
        )
        dateLabel.text = tt_timeStampToCurrentTime(timeStamp: model.latestMsg?.sendTime ?? 0, isMilliSecond: true)
        descLabel.text = model.latestMsg?.content
        guard let lastMsg = model.latestMsg else { return }
        switch lastMsg.contentType {
        case .custom:
            descLabel.text = "[自定义消息]"
        case .image:
            descLabel.text = "[图片]"
        case .text:
            descLabel.text = lastMsg.textElem?.content
        case .audio:
            descLabel.text = "[语音]"
        case .video:
            descLabel.text = "[视频]"
        default:
            break
        }
        
        if model.unreadCount > 0 {
            showBadge(count: model.unreadCount)
        }else {
            removeBadge()
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private let badgeIndex = 11122
    
    func removeBadge() {
        for subview in contentView.subviews {
            if subview.tag == badgeIndex {
                subview.removeFromSuperview()
            }
        }
    }
    
    func showBadge(count: Int) {
        removeBadge()
        
        let bView = UIView()
        bView.tag = badgeIndex
        bView.layer.cornerRadius = 9
        bView.clipsToBounds = true
        bView.backgroundColor = .red
        
        let tabFrame = self.frame
        let percentX = kScreenWidth - 16*2 - 20
        let x = percentX
        let y = CGFloat(ceilf(0.5*Float(tabFrame.height)))
        bView.frame = CGRect(x: x, y: y, width: 18, height: 18)
        
        let cLabel = UILabel()
        cLabel.text = "\(count)"
        cLabel.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        cLabel.font = .systemFont(ofSize: 10)
        cLabel.textColor = .white
        cLabel.textAlignment = .center
        bView.addSubview(cLabel)
        
        contentView.addSubview(bView)
        bringSubviewToFront(bView)
    }
}
