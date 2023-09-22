
class ChatRecordsViewModel: BaseViewModel {

    init(apiService: APIService = .shared) {
        super.init()
        self.apiService = apiService
        setupAlertDelegator(with: self)
    }
    
    var cellHeightCache = [String: CGFloat]()
    
    var mergeElem: OIMMergeElem!
    
    var messages: [OIMMessageInfo] {
        guard let ms = mergeElem.multiMessage else { return [] }
        return ms
    }
}
