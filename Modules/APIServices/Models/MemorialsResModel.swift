
class MemorialsResModel: Codable {
    var data: [MemorialsResItemModel]
    var page: Int = 0
    var page_size: Int = 0
    var total: Int = 0
}

class MemorialsResItemModel: Codable {
    var id: Int = 0
    var type: Int = 0
    var name: String = ""
    var material_url: String = ""
    var img_url: String = ""
    var memorial_id: Int = 0
    var user_id: Int = 0
    var created_at: Int = 0
    var updated_at: Int = 0
}
