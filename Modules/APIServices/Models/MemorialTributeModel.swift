
class MemorialTributeModel: Codable {

    var id: Int = 0
    var name: String = ""
    var icon: String = ""
    var status: Int = 0
    var sort_no: Int = 0
    var created_at: Int = 0
    var updated_at: Int = 0
    var gps: [MemorialTributeListModel]?
}

class MemorialTributeListModel: Codable {
    var id: Int = 0
    var name: String = ""
    var icon: String = ""
    var category_id: Int = 0
    var status: Int = 0
    var desc: String = ""
    var created_at: Int = 0
    var updated_at: Int = 0
    
    var sort_no: Int = 0
    var specs: [MemorialTributeListSpecModel] = []
    
//    private enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case icon
//        case category_id
//        case status
//        case desc
//        case created_at
//        case updated_at
//    }
//
//    override init() {
//        super.init()
//    }
//
//    /// 自定义解码
//    required init(from decoder: Decoder) throws {
//        try super.init(from: decoder)
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: CodingKeys.id)
//        name = try container.decode(String.self, forKey: CodingKeys.name)
//        icon = try container.decode(String.self, forKey: CodingKeys.icon)
//        status = try container.decode(Int.self, forKey: CodingKeys.status)
//        category_id = try container.decode(Int.self, forKey: CodingKeys.category_id)
//        desc = try container.decode(String.self, forKey: CodingKeys.desc)
//        created_at = try container.decode(Int.self, forKey: CodingKeys.created_at)
//        updated_at = try container.decode(Int.self, forKey: CodingKeys.updated_at)
//    }
//
//    /// 自定义编码
//    override func encode(to encoder: Encoder) throws {
//        try super.encode(to: encoder)
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(category_id, forKey: .category_id)
//        try container.encode(icon, forKey: .icon)
//        try container.encode(status, forKey: .status)
//        try container.encode(desc, forKey: .desc)
//        try container.encode(created_at, forKey: .created_at)
//        try container.encode(updated_at, forKey: .updated_at)
//    }
}

class MemorialTributeListSpecModel: Codable {
    var id: Int = 0
    var gp_id: Int = 0
    var name: String = ""
    var desc: String = ""
    var price: Int = 0
    var duration: Int = 0
    var miss_v: Int = 0
    var jd_v: Int = 0
    var status: Int = 0
    var sort_no: Int = 0
    var created_at: Int = 0
    var updated_at: Int = 0
}


class MemorialTributeListBaseModel: Codable {
    var id: Int = 0
    var name: String = ""
    var icon: String = ""
    var category_id: Int = 0
    var status: Int = 0
    var desc: String = ""
    var created_at: Int = 0
    var updated_at: Int = 0
}
