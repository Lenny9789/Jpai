
class ExistingTributeModel: Codable {
    var id: Int = 0
    var gp_id: Int = 0
    var gp_spec_id: Int = 0
    var memorial_id: Int = 0
    var user_id: Int = 0
    var started_at: Int = 0
    var ended_at: Int = 0
    var price: Int = 0
    var miss_v: Int = 0
    var jd_v: Int = 0
    var status: Int = 0
    var created_at: Int = 0
    var updated_at: Int = 0
    var gp: MemorialTributeListBaseModel
    var gp_spec: MemorialTributeListSpecModel
}
