
class FamilyListModel: Codable {

    var id: Int = 0
    var name: String = ""
    var user_id: Int = 0
    var created_at: Int = 0
    var updated_at: Int = 0
    var members: [FamilyMemberModel]
}

class FamilyMemberModel: Codable {
    var id: Int = 0
    var family_id: Int = 0
    var name: String = ""
    var icon: String = ""
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
    var is_birth_remind: Int = 0
    var is_alive: Int = 0
    var relation: String = ""
    var hobby: String = ""
    var remark: String = ""
    var created_at: Int = 0
    var updated_at: Int = 0
}
