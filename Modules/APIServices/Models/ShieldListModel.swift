
class ShieldListModel: Codable {
    var data: [ShieldListItemModel]
    var page: Int = 0
    var page_size: Int = 0
    var total: Int = 0
}

class ShieldListItemModel: Codable {
    var id: Int = 0
    var type: Int = 0
    var ref_id: Int = 0
    var user_id: Int = 0
    var created_at: Int = 0
    var updated_at: Int = 0
    var ref: ShieldListItemDescModel
}

class ShieldListItemDescModel: Codable {
    var nickname: String = ""
    var icon: String = ""
    var realname: String = ""
    var id: Int = 0
    
    var user: WorksUser
    var content: String = ""
}
