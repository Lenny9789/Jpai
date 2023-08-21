import Foundation

public typealias TTElementTuple = (range: NSRange, element: TTActiveElement, type: TTActiveType)

public class TTActiveText {

    /// 解析出文本里包含的@、#、URL、自定义规则等对应内容
    public static func parseTextAndExtractActiveElements(_ text: String, type: TTActiveType) -> [String] {
        let textString = text
        let textLength = textString.count
        let textRange = NSRange(location: 0, length: textLength)
        let filter: ((String) -> Bool)? = nil

        var retItems = [String]()

        func handleURLElements() {
            let tuple = TTActiveBuilder.createURLElements(from: textString, range: textRange, maximumLength: nil)
            let elements = tuple.0
            for element in elements {
                switch element.element {
                case .url(let original, _):
                    retItems.append(original)
                default:
                    break
                }
            }
        }
        
        func handleGeneralElements() {
            let hashtagElements = TTActiveBuilder.createElements(type: .mention, from: textString, range: textRange, filterPredicate: filter)
            for element in hashtagElements {
                switch element.element {
                case .mention(let text):
                    retItems.append(text)
                case .hashtag(let text):
                    retItems.append(text)
                case .url(_, _):
                    break
                case .custom(let text):
                    retItems.append(text)
                }
            }
        }
        
        switch type {
        case .mention:
            handleGeneralElements()
        case .hashtag:
            handleGeneralElements()
        case .custom(_):
            handleGeneralElements()
        case .url:
            handleURLElements()
        }
        
        return retItems
    }
    
}
