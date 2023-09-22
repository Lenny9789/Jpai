import CleanJSON

class OneClickDataModel: Codable {
    var token: String = ""
    var user: UserModel!
}

class UserModel: Codable {
    
    var id: Int = 0
    var nickname: String = ""
    var realname: String = ""
    var name_first_letter: String = "#"
    var icon: String = ""
    var username: String = ""
    var phone: String = ""
    var sex: Int = 0
    var birth_year: Int = 0
    var birth_month: Int = 0
    var birth_day: Int = 0
    var birth_is_lunar: Int = 0
    var birth_is_leap: Int = 0
    var loc_province: String = ""
    var loc_province_id: Int = 0
    var loc_city: String = ""
    var loc_city_id: Int = 0
    var loc_area: String = ""
    var loc_area_id: Int = 0
    var vip_level: Int = 0
    var status: Int = 0
    var remark: String = ""
    var created_at: Int = 0
    var updated_at: Int = 0
}

class UserDetail: UserModel {
    
    var jd_v: Int = 0
    var memorial_cnt: Int = 0
    var post_cnt: Int = 0
    var relation: Relation!
    var wish_v: Int = 0
    var get_wish_v: Int = 0
    
    /// 自定义编码和解码，解决无法覆盖继承的问题
    private enum CodingKeys: String, CodingKey {
        case jd_v
        case memorial_cnt
        case post_cnt
        case relation
        case wish_v
        case get_wish_v
    }

    override init() {
        super.init()
    }
    
    /// 自定义解码
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        jd_v = try container.decode(Int.self, forKey: CodingKeys.jd_v)
        memorial_cnt = try container.decode(Int.self, forKey: CodingKeys.memorial_cnt)
        post_cnt = try container.decode(Int.self, forKey: CodingKeys.post_cnt)
        relation = try container.decode(Relation.self, forKey: CodingKeys.relation)
        wish_v = try container.decode(Int.self, forKey: CodingKeys.wish_v)
        get_wish_v = try container.decode(Int.self, forKey: CodingKeys.get_wish_v)
    }
    
    /// 自定义编码
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jd_v, forKey: .jd_v)
        try container.encode(memorial_cnt, forKey: .memorial_cnt)
        try container.encode(post_cnt, forKey: .post_cnt)
        try container.encode(relation, forKey: .relation)
        try container.encode(wish_v, forKey: .wish_v)
        try container.encode(get_wish_v, forKey: .get_wish_v)
    }
    
    enum Relation: String, Codable, CaseDefaultable {
        static var defaultCase: UserDetail.Relation = .Me
        
        case Me = "self"
        case Friend = "friend"
        case Msr = "msr"
    }
}


