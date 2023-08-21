
class CommentListModel: Codable {

    var id: Int = 0
    var post_id: Int = 0
    var content: String = ""
    var root_id: Int = 0
    var pid_id: Int = 0
    var user_id: Int = 0
    var has_like: Bool
    var like_v: Int = 0
    var created_at: Int = 0
    var updated_at: Int = 0
    var user: WorksUser!
    var reply_user: WorksUser?
    
    var isReply: Bool {
        guard let user = reply_user else {
            return false
        }
        return user.id > 0
    }
}

class CommentModel: Codable {
    var data: [CommentListModel]
    var page: Int = 0
    var page_size: Int = 0
    var total: Int = 0
}
