
class EventListModel: Codable {
    var data: [EventListItemModel]
    var page: Int = 0
    var page_size: Int = 0
    var total: Int = 0
}

class EventListItemModel: Codable {
    var id: Int = 0
    var type: Int = 0
    var memorial_id: Int = 0
    var user_id: Int = 0
    var obj_id: Int = 0
    var obj_name: String = ""
    var obj_icon: String = ""
    var created_at: Int = 0
    var updated_at: Int = 0
    var user: WorksUser
}
