import Foundation

public typealias TTActiveFilterPredicate = ((String) -> Bool)

public struct TTActiveBuilder {

    public static func createElements(type: TTActiveType, from text: String, range: NSRange, filterPredicate: TTActiveFilterPredicate?) -> [TTElementTuple] {
        switch type {
        case .mention, .hashtag:
            return createElementsIgnoringFirstCharacter(from: text, for: type, range: range, filterPredicate: filterPredicate)
        case .url:
            return createElements(from: text, for: type, range: range, filterPredicate: filterPredicate)
        case .custom:
            return createElements(from: text, for: type, range: range, minLength: 1, filterPredicate: filterPredicate)
        }
    }

    public static func createURLElements(from text: String, range: NSRange, maximumLength: Int?) -> ([TTElementTuple], String) {
        let type = TTActiveType.url
        var text = text
        let matches = TTRegexParser.getElements(from: text, with: type.pattern, range: range)
        let nsstring = text as NSString
        var elements: [TTElementTuple] = []

        for match in matches where match.range.length > 2 {
            let word = nsstring.substring(with: match.range)
                .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

            guard let maxLength = maximumLength, word.count > maxLength else {
                let range = maximumLength == nil ? match.range : (text as NSString).range(of: word)
                let element = TTActiveElement.create(with: type, text: word)
                elements.append((range, element, type))
                continue
            }

            let trimmedWord = word.tt_trim(to: maxLength)
            text = text.replacingOccurrences(of: word, with: trimmedWord)
            
            let newRange = (text as NSString).range(of: trimmedWord)
            let element = TTActiveElement.url(original: word, trimmed: trimmedWord)
            elements.append((newRange, element, type))
        }
        return (elements, text)
    }
    
    private static func createElements(from text: String,
                                       for type: TTActiveType,
                                       range: NSRange,
                                       minLength: Int = 2,
                                       filterPredicate: TTActiveFilterPredicate?) -> [TTElementTuple] {

        let matches = TTRegexParser.getElements(from: text, with: type.pattern, range: range)
        let nsstring = text as NSString
        var elements: [TTElementTuple] = []

        for match in matches where match.range.length > minLength {
            let word = nsstring.substring(with: match.range)
                .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if filterPredicate?(word) ?? true {
                let element = TTActiveElement.create(with: type, text: word)
                elements.append((match.range, element, type))
            }
        }
        return elements
    }

    private static func createElementsIgnoringFirstCharacter(from text: String,
                                                             for type: TTActiveType,
                                                             range: NSRange,
                                                             filterPredicate: TTActiveFilterPredicate?) -> [TTElementTuple] {
        let matches = TTRegexParser.getElements(from: text, with: type.pattern, range: range)
        let nsstring = text as NSString
        var elements: [TTElementTuple] = []

        for match in matches where match.range.length > 2 {
            let range = NSRange(location: match.range.location + 1, length: match.range.length - 1)
            var word = nsstring.substring(with: range)
            if word.hasPrefix("@") {
                word.remove(at: word.startIndex)
            }
            else if word.hasPrefix("#") {
                word.remove(at: word.startIndex)
            }

            if filterPredicate?(word) ?? true {
                let element = TTActiveElement.create(with: type, text: word)
                elements.append((match.range, element, type))
            }
        }
        return elements
    }
}
