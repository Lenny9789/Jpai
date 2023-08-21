
class MissVListItemModel: Codable {

    var id: Int = 0
    var memorial_id: Int = 0
    var user_id: Int = 0
    var miss_v: Int = 0
    var jd_v: Int = 0
    var created_at: Int = 0
    var updated_at: Int = 0
    var user: WorksUser
}

class MissVListModel: Codable {
    var data: [MissVListItemModel]
    var page: Int = 0
    var page_size: Int = 0
    var total: Int = 0
}
