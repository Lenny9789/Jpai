import Foundation
#if canImport(CryptoSwift)
import CryptoSwift
#endif

extension String {
    
    /// AES加密
    ///
    /// - Parameters:
    ///   - key: key
    ///   - iv: iv
    /// - Returns: String
    public func aesEncrypt(key: String, iv: String) -> String {
#if canImport(CryptoSwift)
        var result: String = ""
        do {
            // 用UTF8的编码方式將字串转成Data
            let data: Data = self.data(using: String.Encoding.utf8, allowLossyConversion: true)!
            
            // 用AES的方式將Data加密
            let aecEnc: AES = try AES(key: key, iv: iv, padding: .pkcs7)
            let enc = try aecEnc.encrypt(data.bytes)
            
            // 使用Base64編碼方式將Data转回字串
            let encData: Data = Data(bytes: enc, count: enc.count)
            result = encData.base64EncodedString()
        } catch {
            debugPrint("\(error.localizedDescription)")
        }
        return result
#else
        fatalError("Please import `CryptoSwift`")
#endif
    }
    
    /// AES解密
    ///
    /// - Parameters:
    ///   - key: key
    ///   - iv: iv
    /// - Returns: String
    public func aesDecrypt(key: String, iv: String) -> String {
#if canImport(CryptoSwift)
        var result: String = ""
        do {
            // 使用Base64的解碼方式將字串解码后再转换Data
            guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
                debugPrint("Base64解码失败！")
                return ""
            }
            
            // 用AES方式將Data解密
            let aesDec: AES = try AES(key: key, iv: iv, padding: .pkcs7)
            let dec = try aesDec.decrypt(data.bytes)
            
            // 用UTF8的編碼方式将解完密的Data轉回字串
            let desData: Data = Data(bytes: dec, count: dec.count)
            result = String(data: desData, encoding: .utf8)!
        } catch {
            debugPrint("\(error.localizedDescription)")
        }
        return result
#else
        fatalError("Please import `CryptoSwift`")
#endif
    }
}
