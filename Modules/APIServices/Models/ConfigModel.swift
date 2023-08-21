
class ConfigModel: Codable {
    var jd_v_exchange_wish_v_rate: Int = 0
    var is_display_online_ly: Int = 0
    var invite_user_reward_wish_v: Int = 0
    var money_exchange_wish_v_rate: Int = 0
    var gold_vip_price: Int = 0
    var diamond_vip_price: Int = 0
    var register_give_wish_v: Int = 0
    var memorial_diamond_vip_price: Int = 0
    var memorial_gold_vip_price: Int = 0
    var sign_in_reward_wish_v: Int = 0
    var webview_url_config: WebviewConfig!
    var default_pay_products: PayProducts!
    
    var invite_user_text: [String] = []
}

class WebviewConfig: Codable {
    var privacy_policy: String = ""
    var user_agreement: String = ""
    var user_recharge_agreement: String = ""
    var about_app: String = ""
}

class PayProducts: Codable {
    var reward_v: [Int] = []
    var wish_v: [Int] = []
}




var kConfigModel = ConfigModel()


class ReportTypesModel: Codable {
    var id: Int = 0
    var name: String = ""
}

class ReportRecordsModel: Codable {
    var page: Int = 0
    var page_size: Int = 0
    var total: Int = 0
    var data: [ReportRecordsItemModel] = []
}

class ReportRecordsItemModel: Codable {
    var id: Int = 0
    var type_id: Int = 0
    var obj_user_id: Int = 0
    var user_id: Int = 0
    var detail: String = ""
    var img_urls: String = ""
    var status: Int = 0
    var created_at: Int = 0
    var report_type: ReportTypesModel
    var user: WorksUser
}
