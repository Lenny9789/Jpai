
class CommunityWorksModel: Codable {

    var id: Int = 0
    var type: Int = 0
    var title: String = ""
    var content: String = ""
    var img_urls: String = ""
    var user_id: Int = 0
    var perm: Int = 0
    var is_display_position: Int = 0
    var position: String = ""
    var like_v: Int = 0
    var comment_v: Int = 0
    var wish_v: Int = 0
    var share_v: Int = 0
    var status: Int = 0
    var source_id: Int = 0
    var user: WorksUser!
    var music: MusicListItemModel
    var bg_img: BackGroundImageModel
    var has_like: Bool
    var has_wish: Bool
    var created_at: Int = 0
    
    var isMe: Bool { user_id == kUserModel.id }
}

class WorksUser: Codable {
    var id: Int = 0
    var nickname: String = ""
    var realname: String = ""
    var name_first_letter: String = ""
    var icon: String = ""
}

class BackGroundImageModel: Codable {
    var id: Int = 0
    var name: String = ""
    var category_id: String = ""
    var img_url: String = ""
    var status: Int = 0
    var sort_no: Int = 0
}

class CommunityListModel: Codable {
    var data: [CommunityWorksModel]
    var page: Int = 0
    var page_size: Int = 0
    var total: Int = 0
}
