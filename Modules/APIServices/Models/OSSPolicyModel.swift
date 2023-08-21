
class OSSPolicyModel: Codable {

    var StatusCode: Int = 0
    var AccessKeyId: String = ""
    var AccessKeySecret: String = ""
    var SecurityToken: String = ""
    var Endpoint: String = ""
    var Expiration: String = ""
    var BucketName: String = ""
    var BucketDomain: String = ""
    
    var isWillExpirate: Bool {
        if let interval = Expiration.date(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")?.timeIntervalSinceNow {
            if interval < 120 {
              return true
            }else {
                return false
            }
        }else {
            return true
        }
    }
}
