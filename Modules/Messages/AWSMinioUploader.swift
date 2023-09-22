import AWSS3

class AWSMinioUploader: NSObject {
    static let shared = AWSMinioUploader()
    
    private var uploadRequest: AWSS3PutObjectRequest!
    
    func upload(param: JSON, bucketName: String, file: URL) {
        let accessKey = param["AccessKeyID"].stringValue
        let secretKey = param["SecretAccessKey"].stringValue
        let endpoint = param["EndPoint"].stringValue
        
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey,
                                                               secretKey: secretKey)
        let config = AWSServiceConfiguration(
            region: .APSouth1,
            endpoint: AWSEndpoint(urlString: "http://" + endpoint),
            credentialsProvider: credentialsProvider
        )
        AWSServiceManager.default().defaultServiceConfiguration = config
        
        guard let data = NSData(contentsOf: file) else { return }
        let suffix = data.imageFormat.suffixName
        let contentType = "image/\(suffix)"
        let fileNameKey = bucketName + "/" + file.lastPathComponent
        
        guard let uploadRequest = AWSS3PutObjectRequest() else { return }
        self.uploadRequest = uploadRequest
        
        uploadRequest.key = fileNameKey
//        uploadRequest.bucket = bucketName
        uploadRequest.body = data
        uploadRequest.acl = .publicReadWrite
        uploadRequest.contentType = contentType
        uploadRequest.contentLength = NSNumber(value: data.count)
        
        uploadRequest.uploadProgress = { (byteSent, totalSent, totalBytesExpectedToSend) in
            debugPrint("文件上传中, bytesSent: \(byteSent), totalBytesSent: \(totalSent), totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
        }
        
        let obj = AWSS3GetPreSignedURLRequest()
//        obj.bucket = bucketName
        obj.key =  fileNameKey
        obj.httpMethod = .GET
        obj.expires = Date.init(timeIntervalSinceNow: 60)
        
        AWSS3.default().putObject(uploadRequest).continueWith { task in
            debugPrint(task)
            if task.isCompleted {
                debugPrint("上传图片成功", task.result)
            }
            debugPrint("http://" + endpoint + "/" + fileNameKey)
            
            AWSS3PreSignedURLBuilder(configuration: config).getPreSignedURL(obj).continueWith { task in
                debugPrint(task.result)
            }
            return nil
        }
        
        
        
    }
}
