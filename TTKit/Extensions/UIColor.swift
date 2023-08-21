import UIKit

extension UIColor {

    // Hex String -> UIColor
    public convenience init(hex: String) {
        self.init(hex: hex, alpha: nil)
    }
    
    // Hex String -> UIColor
    public convenience init(hex: String, alpha: CGFloat?) {
        // 存储转换后的数值
        var r: UInt64 = 0, g: UInt64 = 0, b: UInt64 = 0
        var a: UInt64 = 0xFF
        var retHex = hex

        // 如果传入的十六进制颜色有前缀，去掉前缀
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            retHex = String(retHex[retHex.index(retHex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#") {
            retHex = String(retHex[retHex.index(retHex.startIndex, offsetBy: 1)...])
        }
        // 如果传入的字符数量不足6位按照后边都为0处理，当然你也可以进行其它操作
        if retHex.count < 6 {
            for _ in 0..<6-retHex.count {
                retHex += "0"
            }
        }

        // 分别进行转换
        if retHex.count == 8 { //8位
            // 红
            Scanner(string: String(retHex[..<retHex.index(retHex.startIndex, offsetBy: 2)])).scanHexInt64(&r)
            // 绿
            Scanner(string: String(retHex[retHex.index(retHex.startIndex, offsetBy: 2)..<retHex.index(retHex.startIndex, offsetBy: 4)])).scanHexInt64(&g)
            // 蓝
            Scanner(string: String(retHex[retHex.index(retHex.startIndex, offsetBy: 4)..<retHex.index(retHex.startIndex, offsetBy: 6)])).scanHexInt64(&b)
            // 透明度
            Scanner(string: String(retHex[retHex.index(retHex.startIndex, offsetBy: 6)..<retHex.index(retHex.startIndex, offsetBy: 8)])).scanHexInt64(&a)
        } else { //6位
            // 红
            Scanner(string: String(retHex[..<retHex.index(retHex.startIndex, offsetBy: 2)])).scanHexInt64(&r)
            // 绿
            Scanner(string: String(retHex[retHex.index(retHex.startIndex, offsetBy: 2)..<retHex.index(retHex.startIndex, offsetBy: 4)])).scanHexInt64(&g)
            // 蓝
            Scanner(string: String(retHex[retHex.index(retHex.startIndex, offsetBy: 4)..<retHex.index(retHex.startIndex, offsetBy: 6)])).scanHexInt64(&b)
        }

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        var retAlpha = CGFloat(a) / 255.0
        if let alpha = alpha {
            retAlpha = alpha
        }

        self.init(red: red, green: green, blue: blue, alpha: retAlpha)
    }
    
    // UIColor -> Hex String
    public var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
         
        let multiplier = CGFloat(255.999999)
         
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
         
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    /// Returns a randomly derived RGB color with a transparency of 1.0
    public class var random: UIColor {
        let red = CGFloat(Int.random(in: 0...255))
        let green = CGFloat(Int.random(in: 0...255))
        let blue = CGFloat(Int.random(in: 0...255))
        return UIColor(red: red/255.0, green: green/255.0, blue:blue/255.0, alpha:1.0)
    }
}
