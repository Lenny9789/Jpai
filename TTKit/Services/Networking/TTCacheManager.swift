import Foundation
import Cache

public enum DaisyExpiry {
    /// Object will be expired in the nearest future
    case never
    /// Object will be expired in the specified amount of seconds
    case seconds(TimeInterval)
    /// Object will be expired on the specified date
    case date(Date)
    
    /// Returns the appropriate date object
    public var expiry: Expiry {
        switch self {
        case .never:
            return Expiry.never
        case .seconds(let seconds):
            return Expiry.seconds(seconds)
        case .date(let date):
            return Expiry.date(date)
        }
    }
    
    public var isExpired: Bool {
        return expiry.isExpired
    }
}

struct TTCacheModel: Codable {
    var data: Data?
    var dataDict: Dictionary<String, Data>?
    init() { }
}

class TTCacheManager: NSObject {
    static let `default` = TTCacheManager()
    /// Manage storage
    private var storage: Storage<String, TTCacheModel>?
    /// init
    override init() {
        super.init()
        expiryConfiguration()
    }
    var expiry: DaisyExpiry = .never
    
    func expiryConfiguration(expiry: DaisyExpiry = .never) {
        self.expiry = expiry
        let diskConfig = DiskConfig(
            name: "DaisyCache",
            expiry: expiry.expiry
        )
        let memoryConfig = MemoryConfig(expiry: expiry.expiry)
        do {
            storage = try Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forCodable(ofType: TTCacheModel.self))
        } catch {
            debugPrint(error)
        }
    }
        
    /// Clear all cache
    ///
    /// - Parameter completion: completion
    func removeAllCache(completion: @escaping (_ isSuccess: Bool)->()) {
        storage?.async.removeAll(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }
    
    /// Clear the cache according to the key value
    ///
    /// - Parameters:
    ///   - cacheKey: cacheKey
    ///   - completion: completion
    func removeObjectCache(_ cacheKey: String, completion: @escaping (_ isSuccess: Bool)->()) {
        storage?.async.removeObject(forKey: cacheKey, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }
    
    /// Read cache
    ///
    /// - Parameter key: key
    /// - Returns: model
    func objectSync(forKey key: String) -> TTCacheModel? {
        do {
            ///Expired clear cache
            if let isExpire = try storage?.isExpiredObject(forKey: key), isExpire {
                removeObjectCache(key) { (_) in }
                return nil
            } else {
                return (try storage?.object(forKey: key)) ?? nil
            }
        } catch {
            return nil
        }
    }
    
    /// Asynchronous cache
    ///
    /// - Parameters:
    ///   - object: model
    ///   - key: key
    func setObject(_ object: TTCacheModel, forKey key: String) {
        storage?.async.setObject(object, forKey: key, expiry: nil, completion: { (result) in
            switch result {
            case .value(_):
                debugPrint("Cached successfully")
            case .error(let error):
                debugPrint("Cached failed: \(error)")
            }
        })
    }
    
    // Using swift Cache,
    // see: https://github.com/hyperoslo/Cache
}
