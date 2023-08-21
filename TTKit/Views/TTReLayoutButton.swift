import UIKit

/// 可重新排列UIButton图片、文字位置
///
open class TTReLayoutButton: UIButton {
    
    public enum LayoutStyle {
        /// 只有文字
        case text
        /// 左文字右图片
        case text_Image(align: AlignStyle)
        /// 左图片右文字
        case image_Text(align: AlignStyle)
        /// 只有图片
        case image
        /// 文字上图片下
        case text_Top_Image_Bottom(align: AlignStyle)
        /// 图片上文字下
        case image_Top_Text_Bottom(align: AlignStyle)
    }

    public enum AlignStyle {
        /// 居中
        case centering(space: CGFloat)
        /// 两端对齐
        case spaceBetween(padding: CGFloat)
        //靠左
        case preferLeft(padding: CGFloat)
        //靠右
        case preferRight(padding: CGFloat)
    }
    
    private var layoutStyle: LayoutStyle?

    public convenience init(style: LayoutStyle) {
        self.init(type: .custom)
        self.layoutStyle = style
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if let layoutStyle = layoutStyle {
            switch layoutStyle {
            case .image:
                break
                
            case .text:
                break
                
            case .image_Text(let align):
                switch align {
                case .centering(let space):
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: space, bottom: 0, right: 0)
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: space)
                    
                case .spaceBetween(let padding):
                    //TODO:
                    let image = self.image(for: .normal)!
                    let titleSize = TTReLayoutButton.getTheSizeOfTitle(title: (self.titleLabel?.text!)!, font: (self.titleLabel?.font)!)

                    let imageTop = (self.frame.size.height - image.size.height) * 0.5
                    let titleTop = (self.frame.size.height - titleSize.height) * 0.5

                    let titleLeft = padding - image.size.width
                    let imageLeft = self.frame.size.width - padding - image.size.width

                    self.contentHorizontalAlignment = .left
                    self.contentVerticalAlignment = .top
                    
                    self.imageEdgeInsets = UIEdgeInsets(top: imageTop, left: imageLeft, bottom: 0, right: 0)
                    self.titleEdgeInsets = UIEdgeInsets(top: titleTop, left: titleLeft, bottom: 0, right: 0)
                    
                case .preferLeft(let padding):
                    let image = self.image(for: .normal)!
                    let titleSize = TTReLayoutButton.getTheSizeOfTitle(title: (self.titleLabel?.text!)!, font: (self.titleLabel?.font)!)

                    let imageTop = (self.frame.size.height - image.size.height) * 0.5
                    let titleTop = (self.frame.size.height - titleSize.height) * 0.5

                    let titleLeft =  image.size.width//self.frame.size.width - padding - image.size.width
                    let imageLeft = padding//padding - image.size.width

                    self.contentHorizontalAlignment = .left
                    self.contentVerticalAlignment = .top
                    
                    self.imageEdgeInsets = UIEdgeInsets(top: imageTop, left: imageLeft, bottom: 0, right: 0)
                    self.titleEdgeInsets = UIEdgeInsets(top: titleTop, left: titleLeft, bottom: 0, right: 0)
                    
                case .preferRight(let padding):
                    let image = self.image(for: .normal)!
                    let titleSize = TTReLayoutButton.getTheSizeOfTitle(title: (self.titleLabel?.text!)!, font: (self.titleLabel?.font)!)

                    let imageTop = (self.frame.size.height - image.size.height) * 0.5
                    let titleTop = (self.frame.size.height - titleSize.height) * 0.5

                    let titleLeft = self.frame.size.width - titleSize.width - titleSize.height - padding
                    let imageLeft = self.frame.size.width - padding - titleSize.width - image.size.width - padding//padding//padding - image.size.width

                    self.contentHorizontalAlignment = .left
                    self.contentVerticalAlignment = .top
                    
                    self.imageEdgeInsets = UIEdgeInsets(top: imageTop, left: imageLeft, bottom: 0, right: 0)
                    self.titleEdgeInsets = UIEdgeInsets(top: titleTop, left: titleLeft, bottom: 0, right: 0)
                }
                
            case .text_Image(let align):
                switch align {
                case .centering(let space):
                    let image = self.image(for: .normal)!
                    let titleSize = TTReLayoutButton.getTheSizeOfTitle(title: (self.titleLabel?.text!)!, font: (self.titleLabel?.font)!)

                    let imageTop = (self.frame.size.height - image.size.height) * 0.5
                    let titleTop = (self.frame.size.height - titleSize.height) * 0.5

                    let titleLeft = (self.frame.size.width-image.size.width-titleSize.width-space)/2-image.size.width
                    let imageLeft = (self.frame.size.width-image.size.width-titleSize.width-space)/2+titleSize.width+space

                    self.contentHorizontalAlignment = .left
                    self.contentVerticalAlignment = .top

                    self.imageEdgeInsets = UIEdgeInsets(top: imageTop, left: imageLeft, bottom: 0, right: 0)
                    self.titleEdgeInsets = UIEdgeInsets(top: titleTop, left: titleLeft, bottom: 0, right: 0)
                    
                case .spaceBetween(let padding):
                    let image = self.image(for: .normal)!
                    let titleSize = TTReLayoutButton.getTheSizeOfTitle(title: (self.titleLabel?.text!)!, font: (self.titleLabel?.font)!)

                    let imageTop = (self.frame.size.height - image.size.height) * 0.5
                    let titleTop = (self.frame.size.height - titleSize.height) * 0.5

                    let titleLeft = padding - image.size.width
                    let imageLeft = self.frame.size.width - padding - image.size.width

                    self.contentHorizontalAlignment = .left
                    self.contentVerticalAlignment = .top
                    
                    self.imageEdgeInsets = UIEdgeInsets(top: imageTop, left: imageLeft, bottom: 0, right: 0)
                    self.titleEdgeInsets = UIEdgeInsets(top: titleTop, left: titleLeft, bottom: 0, right: 0)
                    
                case .preferLeft(_):
                    fatalError("Please implement this `AlignStyle`")
                    break
                case .preferRight(_):
                    fatalError("Please implement this `AlignStyle`")
                    break
                }
                
            case .image_Top_Text_Bottom(let align):
                switch align {
                case .centering(let space):
                    let titleHeight = titleLabel?.bounds.height ?? 0
                    let imageHeight = imageView?.bounds.height ?? 0
                    let imageWidth = imageView?.bounds.width ?? 0
                    let titleWidth = titleLabel?.bounds.width ?? 0
                    let imageTop = (self.frame.size.height-titleHeight-imageHeight-space)/2
                    let titleTop = imageTop+imageHeight+space
                    let imageLeft = (self.frame.size.width-imageWidth)/2
                    // 这里减了image.size.width，因为title的left是以image的left为参考
                    let titleLeft = (self.frame.size.width-titleWidth)/2-imageWidth

                    self.contentHorizontalAlignment = .left
                    self.contentVerticalAlignment = .top

                    imageEdgeInsets = UIEdgeInsets(top: imageTop, left: imageLeft, bottom: 0, right: 0)
                    titleEdgeInsets = UIEdgeInsets(top: titleTop, left: titleLeft, bottom: 0, right: 0)
                    
                case .spaceBetween(_):
                    //TODO:
                    fatalError("Please implement this `AlignStyle`")
                    break
                case .preferLeft(_):
                    fatalError("Please implement this `AlignStyle`")
                    break
                case .preferRight(_):
                    fatalError("Please implement this `AlignStyle`")
                    break
                }
            
            case .text_Top_Image_Bottom(let align):
                switch align {
                case .centering(let space):
                    let titleHeight = titleLabel?.bounds.height ?? 0
                    let imageHeight = imageView?.bounds.height ?? 0
                    let imageWidth = imageView?.bounds.width ?? 0
                    let titleWidth = titleLabel?.bounds.width ?? 0
                    titleEdgeInsets = UIEdgeInsets(
                        top: -(titleHeight + space) * 0.5,
                        left: -imageWidth * 0.5,
                        bottom: space,
                        right: imageWidth * 0.5)
                    imageEdgeInsets = UIEdgeInsets(
                        top: (imageHeight + space),
                        left: titleWidth * 0.5,
                        bottom: 0,
                        right: -titleWidth * 0.5)
                    
                case .spaceBetween(_):
                    //TODO:
                    fatalError("Please implement this `AlignStyle`")
                    break
                case .preferLeft(_):
                    fatalError("Please implement this `AlignStyle`")
                    break
                case .preferRight(_):
                    fatalError("Please implement this `AlignStyle`")
                    break
                }
            }
        }
    }
}

extension TTReLayoutButton {

    ///Gets the size of the title
    public class func getTheSizeOfTitle(title: String, font: UIFont) -> CGSize {
        let size: CGSize = CGSize.init(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        let rect: CGRect = title.boundingRect(
            with: size,
            options: NSStringDrawingOptions.usesFontLeading,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        return rect.size
    }
}
