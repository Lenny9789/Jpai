import Foundation

extension Dictionary {
    
    public init(elements: [Element]) {
        self.init()

        for (key, value) in elements {
            self[key] = value
        }
    }

    public func mapValue<T>(_ transform: (Value) throws -> T) rethrows -> [Key: T] {
        let elements: [(Key, T)] = try compactMap { (key, value) in
            (key, try transform(value))
        }
        return Dictionary<Key, T>(elements: elements)
    }

    public func compactMapValue<T>(_ transform: (Value) throws -> T?) rethrows -> [Key: T] {
        let elements: [(Key, T)] = try compactMap { (key, value) in
            guard let value = try transform(value) else {
                return nil
            }
            return (key, value)
        }
        return Dictionary<Key, T>(elements: elements)
    }
    
    public func jsonObject() throws -> [Key: Value]? {
        return try JSONSerialization.jsonObject(with:
            try JSONSerialization.data(withJSONObject: self))
            as? [Key: Value]
    }
    
    public func jsonString(
        using encoding: String.Encoding = .utf8,
        options: JSONSerialization.WritingOptions = [])
    throws -> String?
    {
        return String(
            data: try JSONSerialization.data(withJSONObject: self, options: options),
            encoding: encoding)
    }
}
