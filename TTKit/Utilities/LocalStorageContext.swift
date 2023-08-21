import Foundation

/// 文件系统路径
///
open class LocalStorageContext {
    public static let domain: String = "com.tt.swift"
    //static let domain: String = Bundle.main.bundleIdentifier!

    public static let shared = LocalStorageContext()

    /// 根目录
    public enum Place {
        case systemCaches //下载文件使用这个目录
        case persistentData
        case documents

        var searchPathDirectory: FileManager.SearchPathDirectory {
            switch self {
            case .systemCaches:
                return .cachesDirectory
            case .persistentData:
                return .applicationSupportDirectory
            case .documents:
                return .documentDirectory
            }
        }
    }
    
    /// 文件夹
    public enum Module {
        case storage
        case media
        case IM(clientID: String)
        
        var path: String {
            switch self {
            case .storage:
                return "storage"
            case .media:
                return "media"
            case .IM(clientID: let clientID):
                return ("IM" as NSString).appendingPathComponent(clientID.md5.lowercased())
            }
        }
    }
    
    /// 文件名
    public enum File {
        // 当前用户
        case userProfile
        // 当前用户信息
        case userInfoProfile
        // 数据库
        case database
        // 自定义文件名
        case custom(String)
        
        var name: String {
            switch self {
            case .userProfile:
                return "user_profile"
            case .userInfoProfile:
                return "user_info_profile"
            case .database:
                return "database.sqlite"
            case .custom(let fileName):
                return fileName
            }
        }
    }
    
    /// 根目录
    public func baseDir(place: Place) -> FileManager.SearchPathDirectory {
        return place.searchPathDirectory
    }
    
    /// 尾部路径
    public func trailingPath(module: Module, file: File) -> String {
        let mp = (LocalStorageContext.domain as NSString).appendingPathComponent(module.path)
        let fp = (mp as NSString).appendingPathComponent(file.name)
        return fp
    }
    
    /// 文件目录
    public func fileDirectoryURL(place: Place, module: Module) throws -> URL {
        let moduleDirectoryURL = (
            try FileManager.default.url(
                for: place.searchPathDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true))
            .appendingPathComponent(
                LocalStorageContext.domain,
                isDirectory: true)
            .appendingPathComponent(
                module.path,
                isDirectory: true)
        try FileManager.default.createDirectory(
            at: moduleDirectoryURL,
            withIntermediateDirectories: true)
        return moduleDirectoryURL
    }
    
    /// 文件地址
    public func fileURL(place: Place, module: Module, file: File) throws -> URL {
        let moduleDirectoryURL = (
            try FileManager.default.url(
                for: place.searchPathDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true))
            .appendingPathComponent(
                LocalStorageContext.domain,
                isDirectory: true)
            .appendingPathComponent(
                module.path,
                isDirectory: true)
        try FileManager.default.createDirectory(
            at: moduleDirectoryURL,
            withIntermediateDirectories: true)
        return moduleDirectoryURL.appendingPathComponent(
            file.name)
    }
    
    /// 移动文件
    public func moveFile(atPath srcURL: URL, toPath dstURL: URL) throws {
        if FileManager.default.fileExists(atPath: dstURL.path) {
            try FileManager.default.replaceItem(
                at: dstURL,
                withItemAt: srcURL,
                backupItemName: nil,
                resultingItemURL: nil)
        } else {
            try FileManager.default.moveItem(
                atPath: srcURL.path,
                toPath: dstURL.path)
        }
    }
    
    /// 拷贝文件到另一个目录
    public func copyFile(atPath srcURL: URL, toPath dstURL: URL) throws -> Bool {
        if FileManager.default.fileExists(atPath: dstURL.path) {
            try FileManager.default.removeItem(atPath: dstURL.path)
        }
        if let data = FileManager.default.contents(atPath: srcURL.path) {
            return FileManager.default.createFile(atPath: dstURL.path, contents: data, attributes: nil)
        }
        return false
    }
    
    /// 保存数据到指定目录
    public func save<T: Codable>(table: T, to fileURL: URL, encoder: JSONEncoder = JSONEncoder()) throws {
        let tempFileURL: URL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(tt_compactUUID)
        try (try encoder.encode(table))
            .write(to: tempFileURL)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.replaceItem(
                at: fileURL,
                withItemAt: tempFileURL,
                backupItemName: nil,
                resultingItemURL: nil)
        } else {
            try FileManager.default.moveItem(
                atPath: tempFileURL.path,
                toPath: fileURL.path)
        }
    }
    
    /// 从指定目录解码数据
    public func table<T: Codable>(from fileURL: URL, decoder: JSONDecoder = JSONDecoder()) throws -> T? {
        guard FileManager.default.fileExists(atPath: fileURL.path),
            let data = FileManager.default.contents(atPath: fileURL.path) else {
                return nil
        }
        return try decoder.decode(T.self, from: data)
    }
    
    /// 清除指定目录数据
    public func clear(file fileURL: URL) throws {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(atPath: fileURL.path)
        }
    }
    
}
