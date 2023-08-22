
import CleanJSON

class JpaiLoginSuccessModel: Codable {

    var H5Token: String = ""
    var H5TokenExpired: Int = 0
    var Id: Int = 0
    var IsNew: Bool = false
    var LastTime: String = ""
    var Phone: String = ""
    var Token: String = ""
    var TokenExpired: Int = 0
}

class JpaiUserInfoModel: Codable {
    
    var Birth: String = ""
    var Email: String = ""
    var Ex: String = ""
    var FaceURL: String = ""
    var Gender: Int = 0
    var Id: Int = 0
    var LastTime: String = ""
    var NickName: String = ""
    var Password: String = ""
    var Phone: String = ""
}
