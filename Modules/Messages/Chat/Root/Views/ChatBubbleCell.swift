
import UIKit

class ChatBubbleCell: ChatMessageCell {

    /// 气泡图片
    lazy var bubbleView: UIImageView = {
        let view = UIImageView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        container.addSubview(bubbleView)
    }
    
    override func fillWith(_ data: OIMMessageInfo) {
        super.fillWith(data)
        
        self.bubbleView.image = UIImage(color: .systemGray5)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bubbleView.whc_ResetConstraints()
        
        bubbleView.whc_AutoSize(left: 0, top: 0, right: 0, bottom: 0)
        
        if curMessage.isInComing() {
            bubbleView.setLayerCorner(radius: 5, corners: [.bottomCorners, .rightSideCorners])
        } else {
            bubbleView.setLayerCorner(radius: 5, corners: [.bottomCorners, .leftSideCorners])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
