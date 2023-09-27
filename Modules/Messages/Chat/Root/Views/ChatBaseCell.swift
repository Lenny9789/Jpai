
import UIKit

class ChatBaseCell: TableViewBaseCell {

    /// 视图事件
    enum Event {
        /// 图像点击
        case avatarTapped
        /// 菜单点击
        case voiceTapped
        ///名片
        case cardTapped
        ///聊天记录
        case mergeTapped
        /// 视频点击
        case videoTapped
        /// 图片点击
        case pictureTapped
        /// 长按
        case longPress
        /// 转发列表
        case forwardList
        /// 喜欢列表
        case likeList
        /// 评论点击
        case commentTapped
        /// 转发点击
        case forwardTapped
        /// 喜欢点击
        case likeTapped
        /// 分享点击
        case shareTapped
        
        case zhufuTapped
        /// @ 点击
        case mentionTapped(text: String)
        /// 群聊链接点击
        case groupChatLinkTapped(text: String)
        ///超链接点击
        case urlTapped(url: URL)
        /// 关键词点击
        case hashTagTapped(text: String)
    }
    
    weak var eventDelegate: ChatCellDelegate?
    
    func setDelegator(delegate: ChatCellDelegate?,
                      indexPath: IndexPath? = nil) {
        self.eventDelegate = delegate
    }
    
    static func cellHeight(_ message: OIMMessageInfo) -> CGFloat {
        var totalHeight: CGFloat = 0
        let titleLabelHeight = 15.0
        let typeValue = message.contentType.rawValue
        switch message.contentType {
        case .text, .image, .video, .audio, .merge, .card, .custom:
            totalHeight += titleLabelHeight
            totalHeight += 5
            totalHeight += message.containerSize().height
            totalHeight += 15
            
        case .friendAdded, .friendDeleted, .friendApplication,
                .friendRemarkSet, .friendAppApproved, .friendAppRejected,
                .blackAdded, .blackDeleted:
            totalHeight = 20
            
        case .groupCreated, .dismissGroup, .groupAppAccepted, .groupAnnouncement,
                .groupInfoSet, .groupAppRejected, .groupOwnerTransferred,
                .memberInvited, .memberEnter, .memberQuit:
            totalHeight = message.containerSize().height
            
            
        default:
            totalHeight = 20
        }
        
        return totalHeight
    }
}

/// 视图代理
protocol ChatCellDelegate: AnyObject {
    /// 视图事件回调
    func cellAction(_ curView: ChatBaseCell,
                    event: ChatBaseCell.Event)
}

extension OIMMessageInfo {
    
    func containerSize() -> CGSize {
        var size: CGSize = .zero
        
        switch contentType {
        case .text:
            let textSize = kMultilineTextSize(
                text: textElem?.content ?? "",
                font: .systemFont(ofSize: 15),
                maxSize: CGSize(width: kScreenWidth - 16*2 - 40 - 10 - 20, height: CGFloat(MAXFLOAT))
            )
            size = CGSize(width: textSize.width + 20, height: textSize.height + 20)
           
        case .card:
            size = CGSize(width: 220, height: 90)
            
        case .merge:
            guard let title = mergeElem?.title else { return size }
            let titleSize = kMultilineTextSize(
                text: title,
                font: .systemFont(ofSize: 18),
                maxSize: CGSize(width: kScreenWidth - 16*2 - 40 - 10 - 20, height: CGFloat(MAXFLOAT))
            )
            size = CGSize(width: titleSize.width + 20, height: titleSize.height + 20 + 60)
            
        case .custom:
            if let c = customElem?.extension, c == "[通话]" {
                guard let data = customElem?.data else { return size }
                let json = JSON(parseJSON: data)
                if json["type"].stringValue == "hang_up" {
                    var str = ""
                    switch json["status"] {
                    case 10:
                        str = "异常断开"
                    case 9:
                        str = isInComing() ? "接入异常" : "对方接入异常"
                    case 8:
                        str = isInComing() ? "对方已取消" : "已取消"
                    case 7:
                        str = isInComing() ? "已拒绝" : "对方已拒绝"
                    default:
                        str = "已挂断"
                    }
                    let textSize = kMultilineTextSize(
                        text: "[通话]: " + str + " ",
                        font: .systemFont(ofSize: 14),
                        maxSize: CGSize(width: kScreenWidth - 16*2 - 40 - 10 - 20, height: CGFloat(MAXFLOAT))
                    )
                    size = CGSize(width: textSize.width + 20, height: textSize.height + 20)
                }
                if json["type"].stringValue == "call_over" {
                    let textSize = kMultilineTextSize(
                        text: json["msg"].stringValue + " ",
                        font: .systemFont(ofSize: 14),
                        maxSize: CGSize(width: kScreenWidth - 16*2 - 40 - 10 - 20, height: CGFloat(MAXFLOAT))
                    )
                    size = CGSize(width: textSize.width + 20, height: textSize.height + 20)
                }
                
                return size
            }
            let textSize = kMultilineTextSize(
                text: customElem?.data ?? "",
                font: .systemFont(ofSize: 14),
                maxSize: CGSize(width: kScreenWidth - 16*2 - 40 - 10 - 20, height: CGFloat(MAXFLOAT))
            )
            size = CGSize(width: textSize.width + 20, height: textSize.height + 20)
            
        case .image:
            guard let snap = pictureElem?.sourcePicture else { return size }
            let size1 = CGSize(width: 160, height: 160/9*16)
            let size2 = CGSize(width: 270, height: 270/4*3)
            if snap.height < snap.width {
                size = size2
            } else {
                size = size1
            }

        case .audio:
            size = CGSize(width: 60, height: 40)
            
        case .video:
            size =  CGSize(width: kScreenWidth/2+100, height: 200)
            
//System Notifi
        case .memberKicked:
            var text = ""
            if let list = notificationElem?.kickedUserList {
                for name in list {
                    text += (name.nickname ?? "") + "\n"
                }
            }
            text += "被你踢出群聊"
            let textSize = kMultilineTextSize(
                text: text,
                font: .systemFont(ofSize: 13),
                maxSize: CGSize(width: kScreenWidth - 16*2 - 40 - 10 - 20, height: CGFloat(MAXFLOAT))
            )
            size = CGSize(width: textSize.width, height: textSize.height + 5)
            
        case .memberInvited:
            var text = (notificationElem?.opUser?.nickname ?? "") + "\n邀请\n"
            if let list = notificationElem?.invitedUserList {
                for name in list {
                    text += (name.nickname ?? "") + "\n"
                }
            }
            text += "加入了群聊"
            let textSize = kMultilineTextSize(
                text: text,
                font: .systemFont(ofSize: 13),
                maxSize: CGSize(width: kScreenWidth - 16*2 - 40 - 10 - 20, height: CGFloat(MAXFLOAT))
            )
            size = CGSize(width: textSize.width, height: textSize.height + 5)
            
        case .memberEnter:
            var text = (notificationElem?.entrantUser?.nickname ?? "") + " 加入了群聊"
            
            let textSize = kMultilineTextSize(
                text: text,
                font: .systemFont(ofSize: 13),
                maxSize: CGSize(width: kScreenWidth - 16*2 - 40 - 10 - 20, height: CGFloat(MAXFLOAT))
            )
            size = CGSize(width: textSize.width, height: textSize.height + 5)
            
        case .memberQuit:
            var text = (notificationElem?.quitUser?.nickname ?? "") + " 退出了群聊"
            
            let textSize = kMultilineTextSize(
                text: text,
                font: .systemFont(ofSize: 13),
                maxSize: CGSize(width: kScreenWidth - 16*2 - 40 - 10 - 20, height: CGFloat(MAXFLOAT))
            )
            size = CGSize(width: textSize.width, height: textSize.height + 5)
            
        case .groupCreated:
            let text = (notificationElem?.opUser?.nickname ?? "") + " 创建了群聊"
            let textSize = kMultilineTextSize(
                text: text,
                font: .systemFont(ofSize: 13),
                maxSize: CGSize(width: kScreenWidth - 16*2 - 40 - 10 - 20, height: CGFloat(MAXFLOAT))
            )
            size = CGSize(width: textSize.width, height: textSize.height + 5)
            
        case .dismissGroup:
            let text = (notificationElem?.opUser?.nickname ?? "") + " 解散了群聊"
            let textSize = kMultilineTextSize(
                text: text,
                font: .systemFont(ofSize: 13),
                maxSize: CGSize(width: kScreenWidth - 16*2 - 40 - 10 - 20, height: CGFloat(MAXFLOAT))
            )
            size = CGSize(width: textSize.width, height: textSize.height + 5)
            
        default:
            break
        }
        
        return size
    }
    
    func isInComing()  -> Bool {
        guard let sendID = sendID, let userID = kUserLoginModel["Id"].int else { return true }
        return sendID != userID.description
    }
}
