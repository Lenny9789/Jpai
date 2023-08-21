
class FriendsModel: Codable {
    var id: Int = 0
    var user_id: Int = 0
    var friend_id: Int = 0
    var status: Int = 0
    var is_applicant: Int = 0
    var created_at: Int = 0
    var updated_at: Int = 0
    var friend: FriendModel!
}

class FriendModel: Codable {
    var id: Int = 0
    var nickname: String = ""
    var realname: String = ""
    var name_first_letter: String = ""
    var icon: String = ""
}

class FriendListItemModel: Codable {
    var friends: [FriendsModel] = []
    var key: String = ""
}
