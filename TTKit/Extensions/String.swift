import UIKit

extension String {
    
    public func toCGFloat() -> CGFloat {
        if let doubleValue = Double(self) {
            return CGFloat(doubleValue)
        }
        return 0.0
    }
    
    public func toFloat() -> Float {
        if let floatValue = Float(self) {
            return floatValue
        } else {
            return 0.0
        }
    }
    
    public func toInt() -> Int {
        if let intValue = Int(self) {
            return intValue
        } else {
            return 0
        }
    }
    
    public func toDouble() -> Double {
        if let DoubleValue = Double(self) {
            return DoubleValue
        } else {
            return 0.0
        }
    }
    
}

extension String {
    
    /*//urlEncode编码
    - (NSString *)urlEncodeStr:(NSString *)input {
        NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
        NSString *upSign = [input stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        return upSign;
    }
    //urlEncode解码
    - (NSString *)decoderUrlEncodeStr: (NSString *) input {
        NSMutableString *outputStr = [NSMutableString stringWithString:input];
        [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[outputStr length])];
        return [outputStr stringByRemovingPercentEncoding];
     }*/
    
    /// URL转码
    public var URLEscaped: String {
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "#") // #不转码
        return self.addingPercentEncoding(withAllowedCharacters: charSet) ?? self
    }
    
    /// 将原始的url编码为合法的url
    public var urlEncode: String {
        var charSet = NSCharacterSet.urlQueryAllowed
        //charSet.remove(charactersIn: "!*'\"();:@&=+$,/?%#[]% ")
        charSet.remove(charactersIn: "?!@#$^&%*+,:;='\"`<>()[]{}/\\| ")
        return self.addingPercentEncoding(withAllowedCharacters: charSet) ?? self
    }
    
    /// 将编码后的url转换回原始的url
    public var urlDecoded: String {
        let ret = self.replacingOccurrences(of: "+", with: "")
        return ret.removingPercentEncoding ?? self
    }
    
    /// 限制最大长度
    public func limitLength(of maxLen: Int) -> String {
        let text = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.utf16.count > maxLen {
            return (text as NSString).substring(to: maxLen)
        } else {
            return text
        }
    }
    
    /// 字符串转Json对象
    public func jsonObject<T>(
            using encoding: String.Encoding = .utf8,
            options: JSONSerialization.ReadingOptions = [])
        throws -> T?
    {
        guard !self.isEmpty,
            let data = self.data(using: encoding) else {
                return nil
        }
        return try JSONSerialization.jsonObject(with: data, options: options) as? T
    }
}

extension String {
     
    //Range转换为NSRange
    public func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)!
        let to = range.upperBound.samePosition(in: utf16)!
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from), length: utf16.distance(from: from, to: to))
    }
    
    //NSRange转换为Range
    public func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}

extension String {
    
    public func getTextHeight(font : UIFont, width : CGFloat)  -> CGFloat {
        let normalText : NSString = self as NSString
        let stringSize = normalText.boundingRect(with:CGSize(width: width, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font:font], context:nil).size
        return stringSize.height
    }
    
    public func getTextWidth(font : UIFont, height : CGFloat)  -> CGFloat {
        let normalText : NSString = self as NSString
        let stringSize = normalText.boundingRect(with:CGSize(width: CGFloat(MAXFLOAT), height:height), options: .usesLineFragmentOrigin, attributes: [.font:font], context:nil).size
        return stringSize.width
    }
    
}

extension String {

    func tt_trim(to maximumCharacters: Int) -> String {
        return "\(self[..<index(startIndex, offsetBy: maximumCharacters)])" + "..."
    }
}

extension String {

    /// 生成随机字符串
    ///
    /// - Parameters:
    ///   - len: 生成字符串长度
    /// - Returns: String
    public static func tt_random(_ len: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(characters.count)))
            ranStr.append(characters[characters.index(characters.startIndex, offsetBy: index)])
        }
        
        return ranStr
    }
}
