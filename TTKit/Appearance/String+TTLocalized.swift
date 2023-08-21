import Foundation
import UIKit

extension String {
    var ttLocalized: String { return NSLocalizedString(self, tableName: TTKitConfiguration.General.localizableTableName, comment: self) }

    public static var localized_seconds : String { return "seconds".ttLocalized }
    public static var localized_minutes : String { return "minutes".ttLocalized }
    public static var localized_hours : String { return "hours".ttLocalized }
    public static var localized_days : String { return "days".ttLocalized }
    public static var localized_months : String { return "months".ttLocalized }
    public static var localized_years : String { return "years".ttLocalized }
    public static var localized_just : String { return "just".ttLocalized }
    public static var localized_yesterday : String { return "yesterday".ttLocalized }    
    public static var localized_of : String { return "of".ttLocalized }
    public static var localized_invalid_data : String { return "invalid_data".ttLocalized }
    public static var localized_un_uesolved : String { return "un_uesolved".ttLocalized }
    public static var localized_token_expired : String { return "token_expired".ttLocalized }
    public static var localized_token_empty : String { return "token_empty".ttLocalized }
    public static var localized_net_connect_lost : String { return "net_connect_lost".ttLocalized }
    public static var localized_request_canceled : String { return "request_canceled".ttLocalized }
    public static var localized_current_controller : String { return "current_controller".ttLocalized }
    public static var localized_tips_kit : String { return "tips_kit".ttLocalized }
    public static var localized_uninstall_alipay : String { return "uninstall_alipay".ttLocalized }
    public static var localized_uninstall_wechat : String { return "uninstall_wechat".ttLocalized }
    public static var localized_install_now : String { return "install_now".ttLocalized }
    public static var localized_upload_failed : String { return "upload_failed".ttLocalized }
}
