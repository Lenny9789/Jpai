
import UIKit

class ChatSystemMessageCell: ChatBaseCell {

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(contentLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var curMessage: OIMMessageInfo!
    
    func fillWith(_ data: OIMMessageInfo) {
        curMessage = data
        
        contentLabel.text = "好友请求已通过"
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        contentLabel.whc_CenterX(0)
            .whc_CenterY(0)
            .whc_WidthAuto()
            .whc_HeightAuto()
    }
}
