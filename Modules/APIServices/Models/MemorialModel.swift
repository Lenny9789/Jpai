
class MemorialListModel: Codable {
    var data: [MemorialListItemModel]
    
    var page: Int = 0
    var age_size: Int = 0
    var total: Int = 0
}

class MemorialCreatModel: Codable {
    var id: Int = 0
    var name: String = ""
}

class MemorialListItemModel: Codable {
    var id: Int = 0
    var name: String = "" // 名称
    var type: Int = 0 // 1: 亲友 2: 名人 3: cw
    var category: Int = 0 // 1: 单人 2: 双人
    var palace: Int = 0  // 1 2 3 4 东西南北
    var level: Int = 0 // 1: 普通 2: 中级 3: 高级
    var music_id: Int = 0 // 音乐id
    var perm: Int = 0 // 1: 公开 2: 好友可见 3: 仅自己
    var sleep_area: String = "" // axd
    var status: Int = 0
    var miss_v: Int = 0  // 思念值
    var wish_v: Int = 0   //收到的祝福值
    var jd_v: Int = 0 // JD值
    var user_id: Int = 0
    var has_like: Bool = false
    var created_at: Int = 0 // 创建时间
    var updated_at: Int = 0
    var members: [MemorialMembersModel]
    var music: MusicListItemModel
    
    var isMe: Bool {
        return user_id == kUserModel.id
    }
}

class MemorialMembersModel: Codable {
    var id: Int = 0
    var name: String = ""
    var sex: Int = 0 // 性别 1: 男  2: 女
    var photo: String = ""  // 相片
    var is_remind: Int = 0 // 是否提醒
    var birth_year: Int = 0
    var birth_month: Int = 0
    var birth_day: Int = 0
    var birth_is_lunar: Int = 0
    var birth_is_leap: Int = 0
    var passaway_year: Int = 0
    var passaway_month: Int = 0
    var passaway_day: Int = 0
    var passaway_is_lunar: Int = 0
    var passaway_is_leap: Int = 0
    var id_number: String = ""  // 身份证号
    var intro: String = "" // 简介
    var memorial_id: Int = 0
    var created_at: Int = 0
    var updated_at: Int = 0
}
