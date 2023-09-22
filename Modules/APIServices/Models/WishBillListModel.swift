
class WishBillListModel: Codable {

    var page: Int = 0
    var page_size: Int = 0
    var total: Int = 0
    var data: [WishBillitemModel] = []
}

class WishBillitemModel: Codable {
    var id: Int = 0
    var type: Int = 0
    var user_id: Int = 0
    var record_operator: String = ""
    var wish_v: Int = 0
    var ref_id: Int = 0
    var ref_user_id: Int = 0
    var desc: String = ""
    var created_at: Int = 0
    
}


class RewardBillListModel: Codable {
    
    var page: Int = 0
    var page_size: Int = 0
    var total: Int = 0
    var data: [RewardBillItemModel] = []
}
class RewardBillItemModel: Codable {
    var id: Int = 0
    var user_id: Int = 0
    var reward_v: Int = 0
    var created_at: Int = 0
    
}
