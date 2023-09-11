
import UIKit

class ChatTextMessageCell: ChatBubbleCell {

    /// 文本内容
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .init(white: 0, alpha: 0.6)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bubbleView.addSubview(contentLabel)
    }
    
    override func fillWith(_ data: OIMMessageInfo) {
        super.fillWith(data)
        
        contentLabel.text = data.textElem?.content
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLabel.whc_ResetConstraints()
        
        if curMessage.isInComing() {
            contentLabel.whc_Left(10)
                .whc_Top(10)
                .whc_Right(10)
                .whc_HeightAuto()
        } else {
            contentLabel.whc_Right(10)
                .whc_Top(10)
                .whc_Left(10)
                .whc_HeightAuto()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
