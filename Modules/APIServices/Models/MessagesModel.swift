
class MessagesModel: Codable {
    var id: Int = 0
    var type: Int = 0
    var subtype: Int = 0
    var user_id: Int = 0
    var ref_id: Int = 0
    var ref_user_id: Int = 0
    var ref_attach_id: Int = 0
    var content: String = ""
    var is_read: Int = 0
    var created_at: Int = 0
    var ref_user: WorksUser
    var title: String = ""
}

class MessagesUnreadModel: Codable {
    var post: Int = 0
    var jng: Int = 0
    var system: Int = 0
    var share: Int = 0
}

class MessageSummaryModel: Codable {
    var last_message_summary: LastSummary
    var no_read_summary: MessagesUnreadModel
}

class LastSummary: Codable {
    var jng: MessagesModel
    var post: MessagesModel
    var share: MessagesModel
    var system: MessagesModel
}

class MessagesListModel: Codable {
    var page: Int = 0
    var page_size: Int = 0
    var total: Int = 0
    var data: [MessagesModel] = []
}


class InviteSummary: Codable {
    var total_cnt: Int = 0
    var total_wish_v: Int = 0
}
