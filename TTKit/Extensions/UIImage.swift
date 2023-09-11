import UIKit

extension UIImage {

    /// Create a `UIImage` from a `UIColor` value
    ///
    /// - Parameters:
    ///     - color: A color value to create `UIImage`.
    ///     - size: size.
    ///
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    public convenience init?(_ bgColor: UIColor, content: String, width: CGFloat) {
        let size = CGSize(width: width, height: width)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        bgColor.set()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let fontWidth = width/1.4/2
        let y = (width - fontWidth*1.3) / 2
        let font = UIFont.systemFont(ofSize: fontWidth)
        let attrs = [NSAttributedString.Key.font: font,
                     NSAttributedString.Key.foregroundColor: UIColor.white]
        if content.count >= 2 {
            let subStr: NSString = String(content.suffix(2)) as NSString;
            let x = (width - subStr.size(withAttributes: attrs).width)/2;
            subStr.draw(at: CGPoint(x: x, y: y), withAttributes:attrs);
        }else if content.count == 1 {
            let x = (width - content.size(withAttributes: attrs).width)/2;
            content.draw(at: CGPoint(x: x, y: y), withAttributes:attrs);
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIImage {
    
    public static func whiteImage(size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        UIColor.white.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    public func jpeg(quality: JPEGQuality = .highest) -> Data? {
        return jpegData(compressionQuality: quality.rawValue)
    }
}

extension UIImage {
    
    public class func imageWithCIQRCode(_ text: String, size:CGFloat) -> UIImage? {
        let strData = text.data(using: .utf8, allowLossyConversion: false)
        // 创建一个二维码的滤镜
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(strData, forKey: "inputMessage")
        qrFilter.setValue(size <= 150 ? "L" : "H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter.outputImage
        // 创建一个颜色滤镜,黑白色
        guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor.black, forKey: "inputColor0")
        colorFilter.setValue(CIColor.white, forKey: "inputColor1")
        
        guard let outputImage = colorFilter.outputImage else { return nil }
        let scale = size / outputImage.extent.size.width
        let image_tr = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        let qrImage = UIImage(ciImage: image_tr)
        return qrImage
    }
    
    // 高清处理
    private func createUIImageFromCIImage(image: CIImage, size: CGFloat) -> UIImage {
        let extent = image.extent.integral
        let scale = min(size / extent.width, size / extent.height)
            
        /// Create bitmap
        let width: size_t = size_t(extent.width * scale)
        let height: size_t = size_t(extent.height * scale)
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmap: CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 1)!
            
        let context = CIContext.init()
        let bitmapImage = context.createCGImage(image, from: extent)
        bitmap.interpolationQuality = .none
        bitmap.scaleBy(x: scale, y: scale)
        bitmap.draw(bitmapImage!, in: extent)
            
        let scaledImage = bitmap.makeImage()
        return UIImage.init(cgImage: scaledImage!)
    }
    
    // 压缩处理 指定压缩后的大小
    public func compress(maxSize: Int = 100*1024) -> UIImage {
        //首先判断原图大小是否在要求内，如果满足要求则不进行压缩
        var compression = 1.0
        var data = self.jpegData(compressionQuality: compression)
        if (data?.count ?? 0) < maxSize {
            return self
        }
        //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality: compression)
            if data!.count < maxSize * 9/10 {
                min = compression
            } else if data!.count > maxSize {
                max = compression
            } else {
                break
            }
        }
        //判断“压处理”的结果是否符合要求
        var resultImage = UIImage(data: data!)
        if data!.count < maxSize{
            debugPrint("JPEG压缩图：\(CGFloat(data!.count)/1024.0)KB")
            return resultImage!
        }
        //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
        var lastDataLength = 0
        while data!.count > maxSize && data!.count != lastDataLength {
            lastDataLength = data!.count
            //获取处理后的尺寸
            let ratio = CGFloat(maxSize) / CGFloat(data!.count)
            let size = CGSize(
                width: resultImage!.size.width*CGFloat(sqrtf(Float(ratio))),
                height: resultImage!.size.height*CGFloat(sqrtf(Float(ratio))))
            //通过图片上下文进行处理图片
            UIGraphicsBeginImageContext(size)
            resultImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            //获取处理后图片的大小
            data = resultImage!.jpegData(compressionQuality: 1)
            debugPrint("JPEG压缩图：\(CGFloat(data!.count)/1024.0)KB")
        }
        return resultImage!
    }
}
