
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
        
        if let content = data.customElem?.data {
            let json = JSON(parseJSON: content)
            if json["type"].stringValue == "hang_up" {
                var str = ""
                switch json["status"] {
                case 10:
                    str = "异常断开"
                case 9:
                    str = data.isInComing() ? "接入异常" : "对方接入异常"
                case 8:
                    str = data.isInComing() ? "对方已取消" : "已取消"
                case 7:
                    str = data.isInComing() ? "已拒绝" : "对方已拒绝"
                default:
                    str = "已挂断"
                }
                contentLabel.text = "[通话]: " + str
            }
            if json["type"].stringValue == "call_over" {
                contentLabel.text = json["msg"].stringValue
            }
        }
        
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
