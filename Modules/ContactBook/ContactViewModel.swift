
class ContactViewModel: BaseViewModel {

    init(apiService: APIService = .shared) {
        super.init()
        self.apiService = apiService
        setupAlertDelegator(with: self)
    }
    
    func fetchConversationID(_ userID: String, completion: @escaping (OIMConversationInfo) -> Void) {
        OIMManager.manager.getOneConversation(
            withSessionType: .C2C,
            sourceID: userID
        ) { [weak self] conversation in
            guard let `self` = self else { return }
            guard let conversation = conversation else {
                return
            }
            
            completion(conversation)
        }
    }
    
    var searchFriendList: [OIMFullUserInfo] = []
    var friendList: [OIMFullUserInfo] = []
    func fetchFriends(completion: @escaping (Bool) -> Void) {
        
        OIMManager.manager.getFriendListWith { [weak self] friends in
            guard let `self` = self else { return }
            guard let friends = friends else {
                completion(false)
                return
            }
            
            self.friendList = friends
            completion(true)
        }
    }
    
    var searchGroup: [OIMGroupInfo] = []
    var groupPresent = "create"
    var groupJoined: [OIMGroupInfo] {
        return groupList.filter { group in
            group.creatorUserID != kUserLoginModel["Id"].intValue.description
        }
    }
    var groupCreate: [OIMGroupInfo] {
        return groupList.filter { group in
            group.creatorUserID == kUserLoginModel["Id"].intValue.description
        }
    }
    private var groupList: [OIMGroupInfo] = []
    func fetchGroups(completion: @escaping (Bool) -> Void) {
        OIMManager.manager.getJoinedGroupListWith { [weak self] groups in
            guard let `self` = self else { return }
            guard let groups = groups else {
                completion(false)
                return
            }
            self.groupList = groups
            completion(true)
        }
    }
    
    
    var newFriendList: [OIMFriendApplication] = []
    func fetchNewFriends(completion: @escaping (Bool) -> Void) {
        
        OIMManager.manager.getFriendApplicationListAsRecipientWith { [weak self] friends in
            guard let `self` = self else { return }
            guard let friends = friends else {
                completion(false)
                return
            }
            
            self.newFriendList = friends
            completion(true)
        }
    }
    
    func acceptFriend(_ userID: String, completion: @escaping (Bool) -> Void) {
        OIMManager.manager.acceptFriendApplication(userID, handleMsg: "") { result in
            debugPrint(result)
            completion(true)
        } onFailure: { code, error in
            completion(false)
            debugPrint("code:\(code)error:\(error)")
        }
    }
}

extension OIMFullUserInfo {
    
    func NickNamePre() -> String {
        guard let nickName = publicInfo?.nickname else {
            return ""
        }
        return String(nickName.prefix(1))
    }
}
