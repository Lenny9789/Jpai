
import UIKit

class ChatBaseCell: TableViewBaseCell {

    /// 视图事件
    enum Event {
        /// 图像点击
        case avatarTapped
        /// 菜单点击
        case voiceTapped
        /// 视频点击
        case videoTapped
        /// 图片点击
        case pictureTapped
        /// 购买点击
        case payTapped
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
        
        if message.contentType.rawValue >= 1201 {
            return 20
        } else {
            totalHeight += titleLabelHeight
            totalHeight += 5
            totalHeight += message.containerSize().height
            totalHeight += 15
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
            
        case .custom:
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
