import Foundation

public enum TTActiveElement {
    case mention(String)
    case hashtag(String)
    case url(original: String, trimmed: String)
    case custom(String)
    
    public static func create(with activeType: TTActiveType, text: String) -> TTActiveElement {
        switch activeType {
        case .mention: return mention(text)
        case .hashtag: return hashtag(text)
        case .url: return url(original: text, trimmed: text)
        case .custom: return custom(text)
        }
    }
}

public enum TTActiveType {
    case mention
    case hashtag
    case url
    case custom(pattern: String)
    
    public var pattern: String {
        switch self {
        case .mention: return TTRegexParser.mentionPattern
        case .hashtag: return TTRegexParser.hashtagPattern
        case .url: return TTRegexParser.urlPattern
        case .custom(let regex): return regex
        }
    }
}

extension TTActiveType: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .mention: hasher.combine(-1)
        case .hashtag: hasher.combine(-2)
        case .url: hasher.combine(-3)
        case .custom(let regex): hasher.combine(regex)
        }
    }
}

public func ==(lhs: TTActiveType, rhs: TTActiveType) -> Bool {
    switch (lhs, rhs) {
    case (.mention, .mention): return true
    case (.hashtag, .hashtag): return true
    case (.url, .url): return true
    case (.custom(let pattern1), .custom(let pattern2)): return pattern1 == pattern2
    default: return false
    }
}
