
class ImageListItemModel: Codable {

    var id: Int = 0
    var name: String = ""
    var status: Int = 0
    var sort_no: Int = 0
    var images: [ImageItemModel]
}

class ImageItemModel: Codable {
    var id: Int = 0
    var name: String = ""
    var category_id: String = ""
    var img_url: String = ""
    var status: Int = 0
    var sort_no: Int = 0
}
