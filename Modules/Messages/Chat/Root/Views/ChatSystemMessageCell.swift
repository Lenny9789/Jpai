
import UIKit

class ChatSystemMessageCell: ChatBaseCell {

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
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
        
        var text = ""
        switch data.contentType {
        case .friendAppApproved:
            let json = JSON(parseJSON: data.notificationElem?.detail ?? "")
            let fromID = json["fromToUserID"].dictionary?["fromUserID"]?.stringValue
            if fromID == kUserInfoModel["Id"].intValue.description {
                text = "您的好友申请已通过"
            } else {
                text = "你们已经成为好友，可以开始聊天了"
            }
        case .groupCreated:
            text = (data.notificationElem?.opUser?.nickname ?? "") + " 创建了群聊"
            
        case .dismissGroup:
            text = (data.notificationElem?.opUser?.nickname ?? "") + " 解散了群聊"
            
        case .memberKicked:
            if let list = data.notificationElem?.kickedUserList {
                for name in list {
                    text += (name.nickname ?? "") + "\n"
                }
            }
            text += "被你踢出群聊"
            
        case .memberInvited:
            text = (data.notificationElem?.opUser?.nickname ?? "") + "\n邀请\n"
            if let list = data.notificationElem?.invitedUserList {
                for name in list {
                    text += (name.nickname ?? "") + "\n"
                }
            }
            text += "加入了群聊"
            
        case .memberEnter:
            text = (data.notificationElem?.entrantUser?.nickname ?? "") + " 加入了群聊"
            
        case .memberQuit:
            text = (data.notificationElem?.quitUser?.nickname ?? "") + " 退出了群聊"
            
        case .isPrivateMessage:
            let json = JSON(parseJSON: data.notificationElem?.detail ?? "")
            let isPrivate = json["isPrivate"].boolValue
            text = isPrivate ? "阅后即焚已开启" : "阅后即焚已关闭"
        default:
            backgroundColor = .random
        }
        contentLabel.text = text
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        contentLabel.whc_CenterX(0)
            .whc_Bottom(0)
            .whc_WidthAuto()
            .whc_HeightAuto()
    }
}
