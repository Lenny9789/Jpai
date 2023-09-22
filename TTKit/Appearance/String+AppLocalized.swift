import Foundation

extension String {
    var localized: String { return NSLocalizedString(self, comment: self) }

    // MARK: - 【通用】 ======================================================
    // MARK: 通用
    static var localized_nextStep : String { return "nextStep".localized }
    static var localized_finish : String { return "finish".localized }
    static var localized_submit : String { return "submit".localized }
    static var localized_save : String { return "save".localized }
    static var localized_send : String { return "send".localized }
    static var localized_search : String { return "search".localized }
    static var localized_delete : String { return "delete".localized }
    static var localized_clear : String { return "clear".localized }
    static var localized_remove : String { return "remove".localized }
    static var localized_add : String { return "add".localized }
    static var localized_refresh : String { return "refresh".localized }
    static var localized_share : String { return "share".localized }
    static var localized_copy : String { return "copy".localized }
    static var localized_copyLink : String { return "copyLink".localized }
    static var localized_copySuccessfully : String { return "copySuccessfully".localized }
    static var localized_paste : String { return "paste".localized }
    static var localized_copiedToClipboard : String { return "copiedToClipboard".localized }
    // MARK: 弹框
    static var localized_hint : String { return "hint".localized }
    static var localized_tips : String { return "tips".localized }
    static var localized_warn : String { return "warn".localized }
    static var localized_cancel : String { return "cancel".localized }
    static var localized_sure : String { return "sure".localized }
    static var localized_confirm : String { return "confirm".localized }
    static var localized_ok : String { return "ok".localized }
    static var localized_finished : String { return "finished".localized }
    static var localized_unfinished : String { return "unfinished".localized }
    static var localized_decideLater : String { return "decideLater".localized }
    static var localized_updateNow : String { return "updateNow".localized }
    // MARK: 资源
    static var localized_picture : String { return "picture".localized }
    static var localized_photo : String { return "photo".localized }
    static var localized_video : String { return "video".localized }
    static var localized_voice : String { return "voice".localized }
    static var localized_pictureBrackets : String { return "pictureBrackets".localized }
    static var localized_videoBrackets : String { return "videoBrackets".localized }
    static var localized_voiceBrackets : String { return "voiceBrackets".localized }
    // MARK: 单位
    static var localized_day : String { return "day".localized }
    static var localized_point : String { return "point".localized }
    static var localized_leaf : String { return "leaf".localized }
    static var localized_diamond : String { return "diamond".localized }
    static var localized_yuan : String { return "yuan".localized }
    static var localized_peoples : String { return "peoples".localized }
    // MARK: 文档操作
    static var localized_dirCreationFailed : String { return "dirCreationFailed".localized }
    static var localized_fileMoveFailed : String { return "fileMoveFailed".localized }
    static var localized_fileDirCreateFailed : String { return "fileDirCreateFailed".localized }
    static var localized_fileDirCreationFailed : String { return "fileDirCreationFailed".localized }
    static var localized_videoCoverSavedFailed : String { return "videoCoverSavedFailed".localized }
    // MARK: 特殊状态
    static var localized_networkError : String { return "networkError".localized }
    static var localized_serverError : String { return "serverError".localized }
    static var localized_noSearchResults : String { return "noSearchResults".localized }
    static var localized_noData : String { return "noData".localized }
    static var localized_noMessage : String { return "noMessage".localized }
    static var localized_touchScreenRetry : String { return "touchScreenRetry".localized }
    static var localized_trySearchOtherKeywords : String { return "trySearchOtherKeywords".localized }
    static var localized_loadFailedClickRetry : String { return "loadFailedClickRetry".localized }
    // MARK: 错误描述
    static var localized_userinfoNotObtainedException : String { return "userinfoNotObtainedException".localized }
    static var localized_objectCreationException : String { return "objectCreationException".localized }
    static var localized_notGetConfigException : String { return "notGetConfigException".localized }
    static var localized_handleFailed : String { return "handleFailed".localized }
    
    // MARK: - 【Tab】 ======================================================
    static var localized_home : String { return "home".localized }
    static var localized_community : String { return "community".localized }
    static var localized_discover : String { return "discover".localized }
    static var localized_chat : String { return "chat".localized }
    static var localized_mine : String { return "mine".localized }
    
    // MARK: - 【首页】 ======================================================
    // MARK: 首页
    static var localized_searchFocusUser : String { return "searchFocusUser".localized }
    static var localized_isNoWorks : String { return "isNoWorks".localized }
    static var localized_pleaseFocusUser : String { return "pleaseFocusUser".localized }
    static var localized_activityJoined : String { return "activityJoined".localized }
    static var localized_activityDate : String { return "activityDate".localized }
    static var localized_activityDetail : String { return "activityDetail".localized }
    static var localized_newestActivity : String { return "newestActivity".localized }
    static var localized_hotCategory : String { return "hotCategory".localized }
    static var localized_subscribeRecommend : String { return "subscribeRecommend".localized }
    static var localized_todayRecommend : String { return "todayRecommend".localized }
    static var localized_allLike : String { return "allLike".localized }
    static var localized_newestWorks : String { return "newestWorks".localized }
    static var localized_more : String { return "more".localized }
    static var localized_packUp : String { return "packUp".localized }
    static var localized_displayMore : String { return "displayMore".localized }
    // MARK: 首页 > 作品
    static var localized_paidResource : String { return "paidResource".localized }
    static var localized_buy : String { return "buy".localized }
    static var localized_buyTime : String { return "buyTime".localized }
    static var localized_comment : String { return "comment".localized }
    static var localized_canNotReply : String { return "canNotReply".localized }
    static var localized_topMost : String { return "topMost".localized }
    static var localized_unTopMost : String { return "unTopMost".localized }
    static var localized_topMostSuccess : String { return "topMostSuccess".localized }
    static var localized_hasUnTopMost : String { return "hasUnTopMost".localized }
    static var localized_deleteWorks : String { return "deleteWorks".localized }
    static var localized_hide : String { return "hide".localized }
    static var localized_block : String { return "block".localized }
    static var localized_reportOther : String { return "reportOther".localized }
    static var localized_cancelForward : String { return "cancelForward".localized }
    static var localized_deleteComment : String { return "deleteComment".localized }
    static var localized_isConfirmDelWorks : String { return "isConfirmDelWorks".localized }
    static var localized_isConfirmDelComments : String { return "isConfirmDelComments".localized }
    static var localized_hideUserHint : String { return "hideUserHint".localized }
    static var localized_blockUserHint : String { return "blockUserHint".localized }
    static var localized_freeTrial : String { return "freeTrial".localized }
    static var localized_buyNow : String { return "buyNow".localized }
    // MARK: 首页 > 作品 > 订阅&购买
    static var localized_permissionsAreSet : String { return "permissionsAreSet".localized }
    static var localized_needSubscribe : String { return "needSubscribe".localized }
    static var localized_subscribeIts : String { return "subscribeIts".localized }
    static var localized_upgradeIts : String { return "upgradeIts".localized }
    static var localized_upgradeToIts : String { return "upgradeToIts".localized }
    static var localized_or : String { return "or".localized }
    static var localized_and : String { return "and".localized }
    static var localized_thisWorksForever : String { return "thisWorksForever".localized }
    static var localized_canNotSubscribe : String { return "canNotSubscribe".localized }
    static var localized_availableToDate : String { return "availableToDate".localized }
    static var localized_select : String { return "select".localized }
    static var localized_subscribeType : String { return "subscribeType".localized }
    static var localized_diamondBalance : String { return "diamondBalance".localized }
    static var localized_diamondBalanceNotEnough : String { return "diamondBalanceNotEnough".localized }
    static var localized_toCharge : String { return "toCharge".localized }
    static var localized_confirmToPay : String { return "confirmToPay".localized }
    static var localized_confirmSubscribeFree : String { return "confirmSubscribeFree".localized }
    static var localized_isConfirmToPay : String { return "isConfirmToPay".localized }
    static var localized_subscribeSuccessful : String { return "subscribeSuccessful".localized }
    // MARK: 首页 > 作品 > 回复弹窗
    static var localized_replay : String { return "replay".localized }
    static var localized_commentReplay : String { return "commentReplay".localized }
    static var localized_countOfReplay : String { return "countOfReplay".localized }
    static var localized_commentInputPlaceHolder : String { return "commentInputPlaceHolder".localized }
    static var localized_wordsNumber : String { return "wordsNumber".localized }
    static var localized_commentEmpty : String { return "commentEmpty".localized }
    // MARK: 首页 > 作品 > 发布 > 文本编辑
    static var localized_whatsNew : String { return "whatsNew".localized }
    static var localized_wordsLimit : String { return "wordsLimit".localized }
    // MARK: 首页 > 作品 > 发布 > 添加资源
    static var localized_addResources : String { return "addResources".localized }
    static var localized_addVideo : String { return "addVideo".localized }
    static var localized_addImage : String { return "addImage".localized }
    static var localized_addImageForVideoSnapshot : String { return "addImageForVideoSnapshot".localized }
    static var localized_addVideoSnapshot : String { return "addVideoSnapshot".localized }
    static var localized_selectFromVideo : String { return "selectFromVideo".localized }
    static var localized_selectFromLibrary : String { return "selectFromLibrary".localized }
    static var localized_preImagesdisplayFree : String { return "preImagesdisplayFree".localized }
    static var localized_mustChooseFourImages : String { return "mustChooseFourImages".localized }
    static var localized_addImagesForVideo : String { return "addImagesForVideo".localized }
    static var localized_mustChooseThreeImages : String { return "mustChooseThreeImages".localized }
    static var localized_videoFrame : String { return "videoFrame".localized }
    static var localized_addImagesOrVideo : String { return "addImagesOrVideo".localized }
    // MARK: 首页 > 作品 > 发布 > 付费设置
    static var localized_selectPaymentType : String { return "selectPaymentType".localized }
    static var localized_free : String { return "free".localized }
    static var localized_subscribe : String { return "subscribe".localized }
    static var localized_subscribeOrPay : String { return "subscribeOrPay".localized }
    static var localized_subscribeAndPay : String { return "subscribeAndPay".localized }
    static var localized_pay : String { return "pay".localized }
    static var localized_payment : String { return "payment".localized }
    static var localized_selectSubscribeType : String { return "selectSubscribeType".localized }
    static var localized_settingWorksPrice : String { return "settingWorksPrice".localized }
    static var localized_worksPrice : String { return "worksPrice".localized }
    static var localized_inputWorksPrice : String { return "inputWorksPrice".localized }
    static var localized_settingFreeLimit : String { return "settingFreeLimit".localized }
    static var localized_isJoinFreeLimit : String { return "isJoinFreeLimit".localized }
    static var localized_freeLimitDays : String { return "freeLimitDays".localized }
    static var localized_maxFreeLimitDays : String { return "maxFreeLimitDays".localized }
    static var localized_createSubscribeGroupNow : String { return "createSubscribeGroupNow".localized }
    // MARK: 首页 > 作品 > 发布 > 回复设置
    static var localized_anyoneCanReply : String { return "anyoneCanReply".localized }
    static var localized_onlySubscribingCanReply : String { return "onlySubscribingCanReply".localized }
    static var localized_onlyMentionedCanReply : String { return "onlyMentionedCanReply".localized }
    static var localized_onlySubscriberCanReply : String { return "onlySubscriberCanReply".localized }
    static var localized_onlySubscribeGroup : String { return "onlySubscribeGroup".localized }
    static var localized_canReply : String { return "canReply".localized }
    // MARK: 首页 > 作品 > 发布 > 发布进度
    static var localized_publish : String { return "publish".localized }
    static var localized_publishCancel : String { return "publishCancel".localized }
    static var localized_publishCancelMessage : String { return "publishCancelMessage".localized }
    static var localized_uploadFailedRetryHint : String { return "uploadFailedRetryHint".localized }
    static var localized_tryAgain : String { return "tryAgain".localized }
    static var localized_continueToNext : String { return "continueToNext".localized }
    static var localized_publishSuccessful : String { return "publishSuccessful".localized }
    static var localized_publishVideoDurationTooLong : String { return "publishVideoDurationTooLong".localized }
    static var localized_publishVideoSizeTooBig : String { return "publishVideoSizeTooBig".localized }
    static var localized_publishVideoSizeLowEndTooBig : String { return "publishVideoSizeLowEndTooBig".localized }
    static var localized_second : String { return "second".localized }
    // MARK: 首页 > 用户列表
    static var localized_recommendForYou : String { return "recommendForYou".localized }
    static var localized_forwardList : String { return "forwardList".localized }
    static var localized_likeList : String { return "likeList".localized }
    static var localized_quoteList : String { return "quoteList".localized }
    static var localized_subscribing : String { return "subscribing".localized }
    static var localized_subscriber : String { return "subscriber".localized }
    static var localized_subscribed : String { return "subscribed".localized }
    
    // MARK: - 【社区】 ======================================================
    // MARK: 社区
    static var localized_newest : String { return "newest".localized }
    static var localized_hottest : String { return "hottest".localized }
    static var localized_user : String { return "user".localized }
    static var localized_word : String { return "word".localized }
    static var localized_searchContent : String { return "searchContent".localized }
    static var localized_searchRecently : String { return "searchRecently".localized }
    static var localized_searchHotWords : String { return "searchHotWords".localized }
    static var localized_communityEmpty : String { return "communityEmpty".localized }
    static var localized_clearHistory : String { return "clearHistory".localized }
    static var localized_whetherToClearTheHistory : String { return "whetherToClearTheHistory".localized }
    static var localized_noWorkYet : String { return "noWorkYet".localized }
    static var localized_subscribeEmtpyTips : String { return "subscribeEmtpyTips".localized }
    static var localized_findUsersWorthSubscribe : String { return "findUsersWorthSubscribe".localized }
    
    // MARK: - 【聊天】 ======================================================
    // MARK: 聊天
    static var localized_watchCompleteVideo : String { return "watchCompleteVideo".localized }
    
    // MARK: - 【聊天】 ======================================================
    // MARK: 聊天
    static var localized_searchPeopleGroup : String { return "searchPeopleGroup".localized }
    static var localized_noResultConvHint : String { return "noResultConvHint".localized }
    static var localized_hideConfirmTitle : String { return "hideConfirmTitle".localized }
    static var localized_hideConvHint : String { return "hideConvHint".localized }
    static var localized_deleteConversation : String { return "deleteConversation".localized }
    static var localized_deleteConvHint : String { return "deleteConvHint".localized }
    // MARK: 聊天 > 聊天引擎
    static var localized_clientNotOpen : String { return "clientNotOpen".localized }
    static var localized_dbException : String { return "dbException".localized }
    static var localized_repetitiveOperation : String { return "repetitiveOperation".localized }
    static var localized_missMessageInfo : String { return "missMessageInfo".localized }
    static var localized_unSupportCategory : String { return "unSupportCategory".localized }
    static var localized_storageNotFound : String { return "storageNotFound".localized }
    static var localized_connectionLostWithAppEnterBg : String { return "connectionLostWithAppEnterBg".localized }
    static var localized_connectionLostWithNetUnavailable : String { return "connectionLostWithNetUnavailable".localized }
    static var localized_connectionLostWithNetChanged : String { return "connectionLostWithNetChanged".localized }
    static var localized_connectionClosedByLocal : String { return "connectionClosedByLocal".localized }
    static var localized_connectionClosedByRemote : String { return "connectionClosedByRemote".localized }
    // MARK: 聊天 > 会话
    static var localized_longPressRecording : String { return "longPressRecording".localized }
    static var localized_letGoOver : String { return "letGoOver".localized }
    static var localized_letGoCancel : String { return "letGoCancel".localized }
    static var localized_swipeUpCancel : String { return "swipeUpCancel".localized }
    static var localized_releaseFingerCancel : String { return "releaseFingerCancel".localized }
    static var localized_timeTooShort : String { return "timeTooShort".localized }
    static var localized_messageUnSupport : String { return "messageUnSupport".localized }
    static var localized_messageRead : String { return "messageRead".localized }
    static var localized_messageUnRead : String { return "messageUnRead".localized }
    static var localized_unauthorizedMicro : String { return "unauthorizedMicro".localized }
    static var localized_missConversationID : String { return "missConversationID".localized }
    // MARK: 聊天 > 会话 > 申请入群
    static var localized_member : String { return "member".localized }
    static var localized_chatGroupName : String { return "chatGroupName".localized }
    static var localized_chatGroupNotice : String { return "chatGroupNotice".localized }
    static var localized_purchaseMode : String { return "purchaseMode".localized }
    static var localized_purchaseModeDescriptions : String { return "purchaseModeDescriptions".localized }
    static var localized_joinApplySuccessful : String { return "joinApplySuccessful".localized }
    static var localized_joined : String { return "joined".localized }
    // MARK: 聊天 > 会话 > 会话信息
    static var localized_addMembers : String { return "addMembers".localized }
    static var localized_subscribeRenewals : String { return "subscribeRenewals".localized }
    static var localized_noSubscribe : String { return "noSubscribe".localized }
    static var localized_turnOffNotify : String { return "turnOffNotify".localized }
    static var localized_turnOnNotify : String { return "turnOnNotify".localized }
    static var localized_clearRecord : String { return "clearRecord".localized }
    static var localized_moreOperate : String { return "moreOperate".localized }
    static var localized_disbandGroup : String { return "disbandGroup".localized }
    static var localized_existGroup : String { return "existGroup".localized }
    static var localized_muteList : String { return "muteList".localized }
    static var localized_groupAddress : String { return "groupAddress".localized }
    static var localized_groupBulletin : String { return "groupBulletin".localized }
    static var localized_joinGroupTime : String { return "joinGroupTime".localized }
    static var localized_removeFromGroup : String { return "removeFromGroup".localized }
    static var localized_mute : String { return "mute".localized }
    static var localized_unMute : String { return "unMute".localized }
    static var localized_unMuted : String { return "unMuted".localized }
    static var localized_isConfirmRenewals : String { return "isConfirmRenewals".localized }
    static var localized_renewalSuc : String { return "renewalSuc".localized }
    static var localized_clearChatHistory : String { return "clearChatHistory".localized }
    static var localized_muteForUser : String { return "muteForUser".localized }
    static var localized_unMuteForUser : String { return "unMuteForUser".localized }
    static var localized_existGroupWarning : String { return "existGroupWarning".localized }
    static var localized_blockInviteForever : String { return "blockInviteForever".localized }
    static var localized_disbandInvalidTips : String { return "disbandInvalidTips".localized }
    static var localized_disbandWarning : String { return "disbandWarning".localized }
    static var localized_areYouSureTo : String { return "areYouSureTo".localized }
    static var localized_removeMember : String { return "removeMember".localized }
    static var localized_removeThisGroupChat : String { return "removeThisGroupChat".localized }
    static var localized_blockJoinForever : String { return "blockJoinForever".localized }
    // MARK: 聊天 > 会话 > 会话信息 > 添加成员
    static var localized_searchUserName : String { return "searchUserName".localized }
    static var localized_filterByMeCreatedSubsGroup : String { return "filterByMeCreatedSubsGroup".localized }
    static var localized_filterByMeSubscribing : String { return "filterByMeSubscribing".localized }
    static var localized_sendInvited : String { return "sendInvited".localized }
    // MARK: 聊天 > 会话 > 会话信息 > 举报
    static var localized_reportContent : String { return "reportContent".localized }
    static var localized_reportGroup : String { return "reportGroup".localized }
    // MARK: 聊天 > 会话 > 会话信息 > 举报 > 举报提交
    static var localized_reportSubmitTitle : String { return "reportSubmitTitle".localized }
    static var localized_reportSubmitContent : String { return "reportSubmitContent".localized }
    static var localized_reportSubmitAdditional : String { return "reportSubmitAdditional".localized }
    static var localized_reportSubmitShieldDesc : String { return "reportSubmitShieldDesc".localized }
    static var localized_reportSubmitHideDesc : String { return "reportSubmitHideDesc".localized }
    static var localized_blockWarning : String { return "blockWarning".localized }
    static var localized_doBlocked : String { return "doBlocked".localized }
    static var localized_hideWarning : String { return "hideWarning".localized }
    static var localized_doHidden : String { return "doHidden".localized }
    static var localized_reportSuc : String { return "reportSuc".localized }
    // MARK: 聊天 > 群聊列表
    static var localized_groupChatList : String { return "groupChatList".localized }
    static var localized_meJoinedGroupChat : String { return "meJoinedGroupChat".localized }
    static var localized_meCreatedGroupChat : String { return "meCreatedGroupChat".localized }
    // MARK: 聊天 > 群聊列表 > 创建群聊
    static var localized_createGroupChat : String { return "createGroupChat".localized }
    static var localized_groupChatName : String { return "groupChatName".localized }
    static var localized_groupChatNamePlaceHolder : String { return "groupChatNamePlaceHolder".localized }
    static var localized_groupChatBulletin : String { return "groupChatBulletin".localized }
    static var localized_groupChatBulletinPlaceHolder : String { return "groupChatBulletinPlaceHolder".localized }
    static var localized_groupChatSetting : String { return "groupChatSetting".localized }
    // MARK: 聊天 > 群聊列表 > 创建群聊 > 付费入群设置
    static var localized_paidSetting : String { return "paidSetting".localized }
    static var localized_freeJoinGroup : String { return "freeJoinGroup".localized }
    static var localized_freeJoinGroupDesc : String { return "freeJoinGroupDesc".localized }
    static var localized_subscribeMemberDesc : String { return "subscribeMemberDesc".localized }
    static var localized_permanentMember : String { return "permanentMember".localized }
    static var localized_permanentMemberDesc : String { return "permanentMemberDesc".localized }
    static var localized_subscribePricePlaceHolder : String { return "subscribePricePlaceHolder".localized }
    static var localized_subscribeTimeLen : String { return "subscribeTimeLen".localized }
    
    // MARK: 【我的】 ======================================================
    // MARK: 我的
    static var localized_userHome : String { return "userHome".localized }
    static var localized_diamondAccount : String { return "diamondAccount".localized }
    static var localized_pCoinAccount : String { return "pCoinAccount".localized }
    static var localized_buyDiamond : String { return "buyDiamond".localized }
    static var localized_meTopUp : String { return "meTopUp".localized }
    static var localized_withdraw : String { return "withdraw".localized }
    static var localized_subscribingUser : String { return "subscribingUser".localized }
    static var localized_subscribingGroupChat : String { return "subscribingGroupChat".localized }
    static var localized_balanceRecords : String { return "balanceRecords".localized }
    static var localized_consumptionRecords : String { return "consumptionRecords".localized }
    static var localized_bankCard : String { return "bankCard".localized }
    static var localized_numberAccount : String { return "numberAccount".localized }
    static var localized_customerService : String { return "customerService".localized }
    static var localized_bind : String { return "bind".localized }
    static var localized_goToBind : String { return "goToBind".localized }
    static var localized_withdrawUnInfo : String { return "withdrawUnInfo".localized }
    static var localized_inputCDKEY : String { return "inputCDKEY".localized }
    static var localized_cdKeyError : String { return "cdKeyError".localized }
    static var localized_pleaseInputCDKEY : String { return "pleaseInputCDKEY".localized }
    static var localized_exchangeSuccessfully : String { return "exchangeSuccessfully".localized }
    static var localized_noBindPhoneAndEmail : String { return "noBindPhoneAndEmail".localized }
    static var localized_bindPhone : String { return "bindPhone".localized }
    static var localized_bindEmail : String { return "bindEmail".localized }
    // MARK: 我的 > 个人主页
    static var localized_rewardList : String { return "rewardList".localized }
    static var localized_editUserInfo : String { return "editUserInfo".localized }
    static var localized_join : String { return "join".localized }
    static var localized_following : String { return "following".localized }
    static var localized_followers : String { return "followers".localized }
    static var localized_works : String { return "works".localized }
    static var localized_freeLimit : String { return "freeLimit".localized }
    static var localized_reply : String { return "reply".localized }
    static var localized_forward : String { return "forward".localized }
    static var localized_like : String { return "like".localized }
    static var localized_notCreatedSubscriptionGroup : String { return "notCreatedSubscriptionGroup".localized }
    // MARK: 我的 > 个人主页 > 打赏列表
    static var localized_rewardDetail : String { return "rewardDetail".localized }
    static var localized_rewardDate : String { return "rewardDate".localized }
    static var localized_rankList : String { return "rankList".localized }
    // MARK: 我的 > 个人主页 > 编辑资料
    static var localized_addBanner : String { return "addBanner".localized }
    static var localized_NickName : String { return "NickName".localized }
    static var localized_NickNameMaxSevenWords : String { return "NickNameMaxSevenWords".localized }
    static var localized_birthday : String { return "birthday".localized }
    static var localized_selectBirthday : String { return "selectBirthday".localized }
    static var localized_noEighteenAge : String { return "noEighteenAge".localized }
    static var localized_personalIntroduce : String { return "personalIntroduce".localized }
    static var localized_inputPersonalIntroduce : String { return "inputPersonalIntroduce".localized }
    // MARK: 我的 > 个人主页 > 打赏
    static var localized_rewardBalanceCustom : String { return "rewardBalanceCustom".localized }
    static var localized_rewardSuccess : String { return "rewardSuccess".localized }
    // MARK: 我的 > 个人主页 > 订阅详情
    static var localized_subscribeDetail : String { return "subscribeDetail".localized }
    static var localized_youHasSubscribed : String { return "youHasSubscribed".localized }
    static var localized_subscribeUpgradeHint : String { return "subscribeUpgradeHint".localized }
    static var localized_subscribeUpgradeDifferenceHint : String { return "subscribeUpgradeDifferenceHint".localized }
    // MARK: 我的 > 个人主页 > 订阅者
    static var localized_createNewGroup : String { return "createNewGroup".localized }
    // MARK: 我的 > 个人主页 > 订阅者 > 分组详情
    static var localized_groupDetails : String { return "groupDetails".localized }
    static var localized_memberList : String { return "memberList".localized }
    // MARK: 我的 > 个人主页 > 订阅者 > 分组详情 > 分组信息
    static var localized_groupInfo : String { return "groupInfo".localized }
    static var localized_groupName : String { return "groupName".localized }
    static var localized_subscribePrice : String { return "subscribePrice".localized }
    static var localized_subscribeDuration : String { return "subscribeDuration".localized }
    static var localized_thirtyDays : String { return "thirtyDays".localized }
    static var localized_selectGroupImage : String { return "selectGroupImage".localized }
    static var localized_groupNameMaxFourWords : String { return "groupNameMaxFourWords".localized }
    static var localized_inputSubscribePrice : String { return "inputSubscribePrice".localized }
    static var localized_inputSubscribeDuration : String { return "inputSubscribeDuration".localized }
    static var localized_createSuccess : String { return "createSuccess".localized }
    static var localized_modifySuccess : String { return "modifySuccess".localized }
    // MARK: 我的 > 钻石充值
    static var localized_diamondTopUp : String { return "diamondTopUp".localized }
    static var localized_inputDiamondAmount : String { return "inputDiamondAmount".localized }
    static var localized_gotoPay : String { return "gotoPay".localized }
    static var localized_topUP : String { return "topUP".localized }
    static var localized_notCurrentlySupported : String { return "notCurrentlySupported".localized }
    // MARK: 我的 > 钻石充值 > 支付
    static var localized_payMethod : String { return "payMethod".localized }
    static var localized_paywithoutcard : String { return "paywithoutcard".localized }
    static var localized_moneySymbol : String { return "moneySymbol".localized }
    static var localized_inputRechargeAmount : String { return "inputRechargeAmount".localized }
    static var localized_getPaymentAccount : String { return "getPaymentAccount".localized }
    static var localized_clickNextToPay : String { return "clickNextToPay".localized }
    static var localized_quickPayment : String { return "quickPayment".localized }
    static var localized_Online_Topup : String { return "Online_Topup".localized }
    static var localized_artificialTransfer : String { return "artificialTransfer".localized }
    static var localized_alipay : String { return "alipay".localized }
    static var localized_wechat : String { return "wechat".localized }
    static var localized_transfer : String { return "transfer".localized }
    static var localized_amount : String { return "amount".localized }
    static var localized_payTheAmount : String { return "payTheAmount".localized }
    static var localized_balance : String { return "balance".localized }
    static var localized_currentUSDTPrice : String { return "currentUSDTPrice".localized }
    static var localized_currentBTCPrice : String { return "currentBTCPrice".localized }
    static var localized_currentETHPrice : String { return "currentETHPrice".localized }
    static var localized_immediatePayment : String { return "immediatePayment".localized }
    static var localized_paymentConfirmation : String { return "paymentConfirmation".localized }
    static var localized_deductionFromWallet : String { return "deductionFromWallet".localized }
    static var localized_getQRCodeAndPaymentAddress : String { return "getQRCodeAndPaymentAddress".localized }
    static var localized_selectPaymentChainAddress : String { return "selectPaymentChainAddress".localized }
    static var localized_selectPaymentMethod : String { return "selectPaymentMethod".localized }
    static var localized_diamondSecondsToAccount : String { return "diamondSecondsToAccount".localized }
    static var localized_chainAddressNotExist : String { return "chainAddressNotExist".localized }
    static var localized_whetherCompletedPayment : String { return "whetherCompletedPayment".localized }
    static var localized_expectedToGet : String { return "expectedToGet".localized }
    static var localized_payable : String { return "payable".localized }
    static var localized_bankCardRecharge : String { return "bankCardRecharge".localized }
    // MARK: 我的 > 钻石充值 > 支付 > 请转账
    static var localized_pleaseTransfer : String { return "pleaseTransfer".localized }
    static var localized_transferAmount : String { return "transferAmount".localized }
    static var localized_nameOfPayee : String { return "nameOfPayee".localized }
    static var localized_bankAccountNumber : String { return "bankAccountNumber".localized }
    static var localized_bankName : String { return "bankName".localized }
    static var localized_transferNamePlaceHolder : String { return "transferNamePlaceHolder".localized }
    static var localized_rechargeConfirm : String { return "rechargeConfirm".localized }
    static var localized_scanToPay : String { return "scanToPay".localized }
    static var localized_rechargeSubmitted : String { return "rechargeSubmitted".localized }
    // MARK: 我的 > 钻石充值 > 充值记录
    static var localized_rechargeRecords : String { return "rechargeRecords".localized }
    static var localized_rechargeDate : String { return "rechargeDate".localized }
    static var localized_serialNumber : String { return "serialNumber".localized }
    static var localized_showThirtyDaysRecords : String { return "showThirtyDaysRecords".localized }
    static var localized_rechargeDiamond : String { return "rechargeDiamond".localized }
    static var localized_rechargeAuditing : String { return "rechargeAuditing".localized }
    static var localized_rechargeSuccess : String { return "rechargeSuccess".localized }
    static var localized_rechargeFailed : String { return "rechargeFailed".localized }
    static var localized_rechargePaymentTypeBank : String { return "rechargePaymentTypeBank".localized }
    static var localized_rechargePaymentTypeUSDT : String { return "rechargePaymentTypeUSDT".localized }
    static var localized_rechargePaymentTypeBTC : String { return "rechargePaymentTypeBTC".localized }
    static var localized_rechargePaymentTypeETH : String { return "rechargePaymentTypeETH".localized }
    static var localized_rechargePaymentTypeDiamond : String { return "rechargePaymentTypeDiamond".localized }
    static var localized_rechargePaymentTypePMoney : String { return "rechargePaymentTypePMoney".localized }
    static var localized_rechargePaymentTypeWechat : String { return "rechargePaymentTypeWechat".localized }
    static var localized_rechargePaymentTypeAlipay : String { return "rechargePaymentTypeAlipay".localized }
    
    // MARK: 我的 > 提现
    static var localized_withdrawMethod : String { return "withdrawMethod".localized }
    static var localized_pleaseSelectAWithdrawalMethod : String { return "pleaseSelectAWithdrawalMethod".localized }
    static var localized_withdrawTo : String { return "withdrawTo".localized }
    static var localized_withdrawTheAmount : String { return "withdrawTheAmount".localized }
    static var localized_withdrawTotal : String { return "withdrawTotal".localized }
    static var localized_PCoin : String { return "PCoin".localized }
    static var localized_inputWithdrawAmount : String { return "inputWithdrawAmount".localized }
    static var localized_pCoinBalance : String { return "pCoinBalance".localized }
    static var localized_singleWithdrawal : String { return "singleWithdrawal".localized }
    static var localized_minmun : String { return "minmun".localized }
    static var localized_maximum : String { return "maximum".localized }
    static var localized_allWithdraw : String { return "allWithdraw".localized }
    static var localized_nonBindingBankCard : String { return "nonBindingBankCard".localized }
    static var localized_dayMaxWithdrawalAmount : String { return "dayMaxWithdrawalAmount".localized }
    static var localized_dayMinWithdrawalAmount : String { return "dayMinWithdrawalAmount".localized }
    static var localized_latestWithdrawalDate : String { return "latestWithdrawalDate".localized }
    static var localized_Withdrawaltimeis : String { return "Withdrawaltimeis".localized }
    static var localized_Pleasetryagainlater : String { return "Pleasetryagainlater".localized }
    static var localized_inputExceedBalance : String { return "inputExceedBalance".localized }
    static var localized_zeroBalance : String { return "zeroBalance".localized }
    static var localized_pcoinsthatcanbewithdrawn : String { return "pcoinsthatcanbewithdrawn".localized }
    static var localized_withdrawNow : String { return "withdrawNow".localized }
    static var localized_notBoundAnyBankCards : String { return "notBoundAnyBankCards".localized }
    static var localized_youAreNotBound : String { return "youAreNotBound".localized }
    static var localized_paymentAddress : String { return "paymentAddress".localized }
    // MARK: 我的 > 提现 > 提现信息确认
    static var localized_withdrawConfirm : String { return "withdrawConfirm".localized }
    static var localized_withdrawalAmount : String { return "withdrawalAmount".localized }
    static var localized_poundage : String { return "poundage".localized }
    static var localized_amountToAccount : String { return "amountToAccount".localized }
    static var localized_cardUserName : String { return "cardUserName".localized }
    static var localized_bankCardNumber : String { return "bankCardNumber".localized }
    static var localized_chainName : String { return "chainName".localized }
    static var localized_chainAddress : String { return "chainAddress".localized }
    static var localized_USDTCurrentPrice : String { return "USDTCurrentPrice".localized }
    static var localized_estimatedAmountOfUSDTReceived : String { return "estimatedAmountOfUSDTReceived".localized }
    static var localized_ETHCurrentPrice : String { return "ETHCurrentPrice".localized }
    static var localized_estimatedAmountOfETHReceived : String { return "estimatedAmountOfETHReceived".localized }
    static var localized_BTCCurrentPrice : String { return "BTCCurrentPrice".localized }
    static var localized_estimatedAmountOfBTCReceived : String { return "estimatedAmountOfBTCReceived".localized }
    static var localized_uploadTransferVoucher : String { return "uploadTransferVoucher".localized }
    static var localized_reupload : String { return "reupload".localized }
    static var localized_tailNumber : String { return "tailNumber".localized }
    // MARK: 我的 > 提现 > 提现记录
    static var localized_withdrawRecords : String { return "withdrawRecords".localized }
    static var localized_withdrawalAuditing : String { return "withdrawalAuditing".localized }
    static var localized_withdrawalApproved : String { return "withdrawalApproved".localized }
    static var localized_withdrawalAuditFailed : String { return "withdrawalAuditFailed".localized }
    static var localized_withdrawing : String { return "withdrawing".localized }
    static var localized_withdrawalSuccessful : String { return "withdrawalSuccessful".localized }
    static var localized_withdrawalApplicationSubmitted : String { return "withdrawalApplicationSubmitted".localized }
    static var localized_withdrawalFailure : String { return "withdrawalFailure".localized }
    static var localized_withdrawPaymentTypeBank : String { return "withdrawPaymentTypeBank".localized }
    static var localized_withdrawPaymentTypeUSDT : String { return "withdrawPaymentTypeUSDT".localized }
    static var localized_withdrawPaymentTypeBTC : String { return "withdrawPaymentTypeBTC".localized }
    static var localized_withdrawPaymentTypeETH : String { return "withdrawPaymentTypeETH".localized }
    // MARK: 我的 > 订阅的用户
    static var localized_renew : String { return "renew".localized }
    static var localized_expireTime : String { return "expireTime".localized }
    static var localized_subscribesLeft : String { return "subscribesLeft".localized }
    static var localized_subscribesExpired : String { return "subscribesExpired".localized }
    static var localized_autoRenew : String { return "autoRenew".localized }
    static var localized_renewConfirm : String { return "renewConfirm".localized }
    static var localized_renewDateTo : String { return "renewDateTo".localized }
    static var localized_openAutoRenewHint : String { return "openAutoRenewHint".localized }
    static var localized_cancelAutoRenewHint : String { return "cancelAutoRenewHint".localized }
    static var localized_setSuccessful : String { return "setSuccessful".localized }
    static var localized_renewSuccessful : String { return "renewSuccessful".localized }
    static var localized_permanent : String { return "permanent".localized }
    // MARK: 我的 > 账变记录
    static var localized_balanceRecordsType : String { return "balanceRecordsType".localized }
    static var localized_orderNo : String { return "orderNo".localized }
    static var localized_manuallyAdjustedDiamond : String { return "manuallyAdjustedDiamond".localized }
    static var localized_subscribeConsumption : String { return "subscribeConsumption".localized }
    static var localized_articleConsumption : String { return "articleConsumption".localized }
    static var localized_promoteConsumption : String { return "promoteConsumption".localized }
    static var localized_promoteReward : String { return "promoteReward".localized }
    static var localized_exceptionalConsumption : String { return "exceptionalConsumption".localized }
    static var localized_commissionIncome : String { return "commissionIncome".localized }
    static var localized_withdrawalRefused : String { return "withdrawalRefused".localized }
    static var localized_subscribeIncome : String { return "subscribeIncome".localized }
    static var localized_articleIncome : String { return "articleIncome".localized }
    static var localized_manuallyAdjustedPCoin : String { return "manuallyAdjustedPCoin".localized }
    static var localized_exceptionalIncome : String { return "exceptionalIncome".localized }
    static var localized_promoteIncome : String { return "promoteIncome".localized }
    static var localized_rechargeWallet : String { return "rechargeWallet".localized }
    // MARK: 我的 > 购买历史
    static var localized_purchaseHistory : String { return "purchaseHistory".localized }
    static var localized_paidWorks : String { return "paidWorks".localized }
    static var localized_mySubscribe : String { return "mySubscribe".localized }
    static var localized_reward : String { return "reward".localized }
    static var localized_subscribeTime : String { return "subscribeTime".localized }
    static var localized_paycontentDeleteTipMessage : String { return "paycontentDeleteTipMessage".localized }
    // MARK: 我的 > 银行卡
    static var localized_bankManager : String { return "bankManager".localized }
    static var localized_USDTWithdrawalManager : String { return "USDTWithdrawalManager".localized }
    static var localized_BTCWithdrawalManager : String { return "BTCWithdrawalManager".localized }
    static var localized_ETHWithdrawalManager : String { return "ETHWithdrawalManager".localized }
    // MARK: 我的 > 银行卡 > 银行卡管理
    static var localized_addBankCard : String { return "addBankCard".localized }
    static var localized_onlyOneBankCard : String { return "onlyOneBankCard".localized }
    static var localized_deleteCardConfirmation : String { return "deleteCardConfirmation".localized }
    static var localized_deleteBankCardSuccessful : String { return "deleteBankCardSuccessful".localized }
    // MARK: 我的 > 银行卡 > 银行卡管理 > 添加银行卡
    static var localized_addBankCardHint : String { return "addBankCardHint".localized }
    static var localized_cardUser : String { return "cardUser".localized }
    static var localized_inputCardUserName : String { return "inputCardUserName".localized }
    static var localized_inputBankCardNumber : String { return "inputBankCardNumber".localized }
    static var localized_inputBankName : String { return "inputBankName".localized }
    static var localized_bankCode : String { return "bankCode".localized }
    static var localized_bank : String { return "bank".localized }
    static var localized_address : String { return "address".localized }
    // MARK: 我的 > 银行卡 > 银行卡管理 > 添加银行卡 > 信息确认
    static var localized_infoConfirmation : String { return "infoConfirmation".localized }
    static var localized_checkBankCardTips : String { return "checkBankCardTips".localized }
    static var localized_addBankCardSuccessful : String { return "addBankCardSuccessful".localized }
    static var localized_checkChainTips : String { return "checkChainTips".localized }
    // MARK: 我的 > 银行卡 > 提现管理
    static var localized_addChainAddress : String { return "addChainAddress".localized }
    static var localized_deleteSuccessful : String { return "deleteSuccessful".localized }
    // MARK: 我的 > 银行卡 > 提现管理 > 添加链地址
    static var localized_inputCorrectChainAddressHint : String { return "inputCorrectChainAddressHint".localized }
    static var localized_currencyType : String { return "currencyType".localized }
    static var localized_chain : String { return "chain".localized }
    static var localized_inputChainAddress : String { return "inputChainAddress".localized }
    static var localized_receiveAddress : String { return "receiveAddress".localized }
    static var localized_inputReceiveAddress : String { return "inputReceiveAddress".localized }
    static var localized_addChainAddressSuccessful : String { return "addChainAddressSuccessful".localized }
    // MARK: 我的 > 钱包
    static var localized_wallet : String { return "wallet".localized }
    static var localized_accountBalance : String { return "accountBalance".localized }
    static var localized_transferToWalletHint : String { return "transferToWalletHint".localized }
    // MARK: 我的 > 设置
    static var localized_setupAndPrivacy : String { return "setupAndPrivacy".localized }
    static var localized_setup : String { return "setup".localized }
    static var localized_account : String { return "account".localized }
    static var localized_privacy : String { return "privacy".localized }
    static var localized_username : String { return "username".localized }
    static var localized_emailAddress : String { return "emailAddress".localized }
    static var localized_hasBlockedAccounts : String { return "hasBlockedAccounts".localized }
    static var localized_subscriptionGroupManagement : String { return "subscriptionGroupManagement".localized }
    static var localized_waterMarkSettings : String { return "waterMarkSettings".localized }
    static var localized_clearCache : String { return "clearCache".localized }
    static var localized_about : String { return "about".localized }
    static var localized_cancelAccount : String { return "cancelAccount".localized }
    static var localized_addPhone : String { return "addPhone".localized }
    static var localized_addEmail : String { return "addEmail".localized }
    static var localized_clickModify : String { return "clickModify".localized }
    static var localized_signOut : String { return "signOut".localized }
    // MARK: 我的 > 设置 > 更新用户名
    static var localized_updateUserName : String { return "updateUserName".localized }
    static var localized_current : String { return "current".localized }
    static var localized_new : String { return "new".localized }
    static var localized_inputNamePlaceHolder : String { return "inputNamePlaceHolder".localized }
    static var localized_usernameTip : String { return "usernameTip".localized }
    static var localized_updateUserNameSuccessful : String { return "updateUserNameSuccessful".localized }
    static var localized_usernameInvalid : String { return "usernameInvalid".localized }
    // MARK: 我的 > 设置 > 更换手机号码 > 验证你的身份
    static var localized_verifyYourIdentity : String { return "verifyYourIdentity".localized }
    static var localized_verifyYourPassword : String { return "verifyYourPassword".localized }
    static var localized_verifyYourPasswordHint : String { return "verifyYourPasswordHint".localized }
    // MARK: 我的 > 设置 > 更换手机号码 > 更换手机号码
    static var localized_changePhoneNumber : String { return "changePhoneNumber".localized }
    static var localized_addPhoneNumberHint : String { return "addPhoneNumberHint".localized }
    static var localized_addPhoneNumber : String { return "addPhoneNumber".localized }
    static var localized_phoneNumberAreaContent : String { return "phoneNumberAreaContent".localized }
    static var localized_phoneNumber : String { return "phoneNumber".localized }
    // MARK: 我的 > 设置 > 更换电子邮箱
    static var localized_changeEmailAddress : String { return "changeEmailAddress".localized }
    static var localized_addEmailAddress : String { return "addEmailAddress".localized }
    static var localized_addEmailHint : String { return "addEmailHint".localized }
    static var localized_yourCurrentEmailAddressIs : String { return "yourCurrentEmailAddressIs".localized }
    static var localized_emailAddressChangeDescription : String { return "emailAddressChangeDescription".localized }
    static var localized_emailAddressChangePlaceHolder : String { return "emailAddressChangePlaceHolder".localized }
    // MARK: 我的 > 设置 > 更改密码
    static var localized_updatePassword : String { return "updatePassword".localized }
    static var localized_currentPassword : String { return "currentPassword".localized }
    static var localized_inputCurrentPassword : String { return "inputCurrentPassword".localized }
    static var localized_newPassword : String { return "newPassword".localized }
    static var localized_inputPasswordPlaceHolder : String { return "inputPasswordPlaceHolder".localized }
    static var localized_repeatPassword : String { return "repeatPassword".localized }
    static var localized_confirmPassword : String { return "confirmPassword".localized }
    static var localized_operationConfirm : String { return "operationConfirm".localized }
    static var localized_isOperationConfirm : String { return "isOperationConfirm".localized }
    static var localized_isConfirmToDo : String { return "isConfirmToDo".localized }
    static var localized_changePasswordSuccess : String { return "changePasswordSuccess".localized }
    static var localized_passwordSet : String { return "passwordSet".localized }
    static var localized_passwordSetSuccess : String { return "passwordSetSuccess".localized }
    // MARK: 我的 > 设置 > 已屏蔽的账号
    static var localized_blockedAccounts : String { return "blockedAccounts".localized }
    static var localized_searchMembers : String { return "searchMembers".localized }
    static var localized_removeFromList : String { return "removeFromList".localized }
    static var localized_removeSuccess : String { return "removeSuccess".localized }
    // MARK: 我的 > 设置 > 已隐藏的账号
    static var localized_hasHideAccounts : String { return "hasHideAccounts".localized }
    // MARK: 我的 > 设置 > 订阅组管理
    static var localized_subscriptionGroupList : String { return "subscriptionGroupList".localized }
    static var localized_subscriptionGroupInfo : String { return "subscriptionGroupInfo".localized }
    static var localized_addSubscriptionGroup : String { return "addSubscriptionGroup".localized }
    // MARK: 我的 > 设置 > 水印设置
    static var localized_waterMarkSettingsSwitch : String { return "waterMarkSettingsSwitch".localized }
    static var localized_waterMarkText : String { return "waterMarkText".localized }
    static var localized_nameUpToSevenCharacters : String { return "nameUpToSevenCharacters".localized }
    // MARK: 我的 > 设置 > 清除缓存
    static var localized_areYouSureYouWantToClearTheCache : String { return "areYouSureYouWantToClearTheCache".localized }
    static var localized_cacheCleared : String { return "cacheCleared".localized }
    // MARK: 我的 > 设置 > 关于
    static var localized_version : String { return "version".localized }
    static var localized_checkForUpdates : String { return "checkForUpdates".localized }
    static var localized_newVersionFound : String { return "newVersionFound".localized }
    static var localized_alreadyLatestVersion : String { return "alreadyLatestVersion".localized }
    // MARK: 我的 > 设置 > 注销账户
    static var localized_cancelAccountDescription : String { return "cancelAccountDescription".localized }
    // MARK: 我的 > 夜间模式
    static var localized_darkMode : String { return "darkMode".localized }
    static var localized_followDevice : String { return "followDevice".localized }
    static var localized_followDeviceTips : String { return "followDeviceTips".localized }
    static var localized_theTheme : String { return "theTheme".localized }
    // MARK: 我的 > 通知
    static var localized_notice : String { return "notice".localized }
    static var localized_all : String { return "all".localized }
    static var localized_mention : String { return "mention".localized }
    static var localized_somebodyBuyWorks : String { return "somebodyBuyWorks".localized }
    static var localized_somebodyForwardWorks : String { return "somebodyForwardWorks".localized }
    static var localized_somebodyLikeWorks : String { return "somebodyLikeWorks".localized }
    static var localized_somebodyLikeComments : String { return "somebodyLikeComments".localized }
    static var localized_somebodySubscribed : String { return "somebodySubscribed".localized }
    static var localized_somebodyReward : String { return "somebodyReward".localized }
    static var localized_subscribeSuccess : String { return "subscribeSuccess".localized }
    static var localized_unsubscribed : String { return "unsubscribed".localized }
    static var localized_andAdditionally : String { return "andAdditionally".localized }
    static var localized_followed : String { return "followed".localized }
    
    // MARK: - 【注册/登陆】 ======================================================
    // MARK: 注册/登陆
    static var localized_registerStartTitle : String { return "registerStartTitle".localized }
    static var localized_createAccount : String { return "createAccount".localized }
    static var localized_hasAccount : String { return "hasAccount".localized }
    static var localized_login : String { return "login".localized }
    static var localized_register : String { return "register".localized }
    static var localized_rememberPassword : String { return "rememberPassword".localized }
    static var localized_rememberAccount : String { return "rememberAccount".localized }
    // MARK: 登录/欢迎页
    static var localized_accountLogin : String { return "accountLogin".localized }
    static var localized_tryItNow : String { return "tryItNow".localized }
    // MARK: 注册 > 创建您的账号
    static var localized_createAccountTitle : String { return "createAccountTitle".localized }
    static var localized_chainAreaCode : String { return "chainAreaCode".localized }
    static var localized_china : String { return "china".localized }
    static var localized_phone : String { return "phone".localized }
    static var localized_namePlaceHolder : String { return "namePlaceHolder".localized }
    static var localized_accountAllPlaceHolder : String { return "accountAllPlaceHolder".localized }
    static var localized_accountPhonePlaceHolder : String { return "accountPhonePlaceHolder".localized }
    static var localized_accountMailPlaceHolder : String { return "accountMailPlaceHolder".localized }
    static var localized_switchToPhone : String { return "switchToPhone".localized }
    static var localized_switchToMail : String { return "switchToMail".localized }
    static var localized_birthdayPlaceHolder : String { return "birthdayPlaceHolder".localized }
    static var localized_agreeServiceAndPrivacy : String { return "agreeServiceAndPrivacy".localized }
    static var localized_serviceTerm : String { return "serviceTerm".localized }
    static var localized_privacyPolicy : String { return "privacyPolicy".localized }
    static var localized_birthdayWarning : String { return "birthdayWarning".localized }
    static var localized_nickNameInvalid : String { return "nickNameInvalid".localized }
    static var localized_phoneInvalid : String { return "phoneInvalid".localized }
    static var localized_emailInvalid : String { return "emailInvalid".localized }
    static var localized_passwordLengthMinPre : String { return "passwordLengthMinPre".localized }
    static var localized_passwordLengthMinEnd : String { return "passwordLengthMinEnd".localized }
    static var localized_repeatedPasswordDifferent : String { return "repeatedPasswordDifferent".localized }
    static var localized_verifyPhone : String { return "verifyPhone".localized }
    static var localized_verifyEmail : String { return "verifyEmail".localized }
    static var localized_weWillSendCodeAsSMSTo : String { return "weWillSendCodeAsSMSTo".localized }
    static var localized_weWillSendCodeAsEmailTo : String { return "weWillSendCodeAsEmailTo".localized }
    static var localized_textTheVerificationCodeTo : String { return "textTheVerificationCodeTo".localized }
    static var localized_emailTheVerificationCodeTo : String { return "emailTheVerificationCodeTo".localized }
    // MARK: 注册 > 选择国家
    static var localized_areaCode : String { return "areaCode".localized }
    // MARK: 注册 > 我们向您发送了验证码
    static var localized_sendCodeToYou : String { return "sendCodeToYou".localized }
    static var localized_inputVerify : String { return "inputVerify".localized }
    static var localized_resendSMS : String { return "resendSMS".localized }
    static var localized_codeHasBeenSent : String { return "codeHasBeenSent".localized }
    static var localized_checkSuccess : String { return "checkSuccess".localized }
    static var localized_changePhoneNumberSuccess : String { return "changePhoneNumberSuccess".localized }
    static var localized_changeEmailSuccess : String { return "changeEmailSuccess".localized }
    static var localized_addPhoneNumberSuccess : String { return "addPhoneNumberSuccess".localized }
    static var localized_addEmailSuccess : String { return "addEmailSuccess".localized }
    static var localized_accountDeleteSuccess : String { return "accountDeleteSuccess".localized }
    // MARK: 注册 > 您需要一个密码
    static var localized_youNeedPassword : String { return "youNeedPassword".localized }
    static var localized_passwordEnsure : String { return "passwordEnsure".localized }
    static var localized_password : String { return "password".localized }
    static var localized_passwordPlaceHolder : String { return "passwordPlaceHolder".localized }
    static var localized_standardPassword : String { return "standardPassword".localized }
    static var localized_registerSuccess : String { return "registerSuccess".localized }
    // MARK: 注册 > 挑选一个个人资料图片
    static var localized_selectInfoImage : String { return "selectInfoImage".localized }
    static var localized_uploadFavoriteSelfie : String { return "uploadFavoriteSelfie".localized }
    static var localized_skipForNow : String { return "skipForNow".localized }
    // MARK: 注册 > 推荐订阅
    static var localized_recommendSubscribe : String { return "recommendSubscribe".localized }
    static var localized_recommendSubscribeDescriptions : String { return "recommendSubscribeDescriptions".localized }
    // MARK: 登陆
    static var localized_accountPlaceHolder : String { return "accountPlaceHolder".localized }
    static var localized_checkAccountCorrect : String { return "checkAccountCorrect".localized }
    static var localized_forgetPassword : String { return "forgetPassword".localized }
    static var localized_loginSuccessful : String { return "loginSuccessful".localized }
    static var localized_reLoginTitle : String { return "reLoginTitle".localized }
    static var localized_reLoginMessage : String { return "reLoginMessage".localized }
    // MARK: 登陆 > 重置密码 > 找到您的账号
    static var localized_resetPassword : String { return "resetPassword".localized }
    static var localized_findYourAccount : String { return "findYourAccount".localized }
    static var localized_notBindAccountTip : String { return "notBindAccountTip".localized }
    static var localized_contactCustomerService : String { return "contactCustomerService".localized }
    // MARK: 登陆 > 重置密码 > 认证您的个人信息
    static var localized_confirmYourInfo : String { return "confirmYourInfo".localized }
    static var localized_confirmPlaceHolder : String { return "confirmPlaceHolder".localized }
    // MARK: 登陆 > 重置密码 > 您想要通过何种方式重置密码
    static var localized_findPassword : String { return "findPassword".localized }
    static var localized_setPassword : String { return "setPassword".localized }
    static var localized_methodYouSelectResetPassword : String { return "methodYouSelectResetPassword".localized }
    static var localized_methodYouSelectResetPasswordDescriptions : String { return "methodYouSelectResetPasswordDescriptions".localized }
    static var localized_phoneTailIs : String { return "phoneTailIs".localized }
    static var localized_sendVerificationCodeToThePhone : String { return "sendVerificationCodeToThePhone".localized }
    static var localized_emailTo : String { return "emailTo".localized }
    static var localized_sendVerificationCodeToTheEmail : String { return "sendVerificationCodeToTheEmail".localized }
    // MARK: 登陆 > 重置密码 > 设置您的密码
    static var localized_setYourPassword : String { return "setYourPassword".localized }
    static var localized_resetPasswordPlaceHolder : String { return "resetPasswordPlaceHolder".localized }
    // MARK: 登陆 > 重置密码 > 您已成功重置密码
    static var localized_resetPasswordSuccess : String { return "resetPasswordSuccess".localized }
    static var localized_continueToHome : String { return "continueToHome".localized }
    
    
    // MARK: - 【图片】 ======================================================
    static var localized_works_pay_for_look : String { return "works_pay_for_look".localized }
    static var localized_wallet_ad : String { return "wallet_ad".localized }
}
