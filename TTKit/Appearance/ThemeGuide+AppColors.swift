import UIKit
import SwiftTheme


/// 定义App中使用的所有颜色
///
extension ThemeGuide {
    
    public enum Colors {
        
        // MARK: 浅色主题配色(白天)[START]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        // MARK: - 主色
        private static let hexPrimaryDay              = "#0c7dff"     //主色（rgb 12 125 255）
        private static let hexAssistDay               = "#94a3b2"     //辅助色（rgb 148 163 178）
        // MARK: - 背景色
        private static let hexForegroundDay           = "#ffffff"     //前景色（rgb 255 255 255）
        private static let hexBackgroundDay           = "#f5f5f5"     //背景色（rgb 245 245 245）
        private static let hexBackgroundHighDay       = "#ededed"     //背景高亮色（rgb 237 237 237）
        private static let hexTextBackgroundDay       = "#e9e9e9"     //输入文本背景色（rgb 233 233 233）
        private static let hexSeparatorDay            = "#efefef"     //分割线（rgb 239 239 239）
        // MARK: - 文本
        private static let hexTitleDay                = "#000000"     //标题（rgb 0 0 0）
        private static let hexSubTitleDay             = "#000000"     //子标题（rgb 0 0 0）
        private static let hexBodyDay                 = "#666666"     //正文（rgb 102 102 102）
        // MARK: - 弹框
        private static let hexPopBgDay                = "#ffffff"     //弹窗背景（rgb 255 255 255）
        private static let hexPopBodyDay              = "#00000099"   //弹窗正文（rgba 102 102 102, 0.6）
        // MARK: - Tab栏
        private static let hexTabTintUnDay            = "#919aab"     //Tab栏标题未选中色（rgb 145 154 171）
        private static let hexTabTintSelectDay        = "#a565ff"     //Tab栏标题选中色（rgb 165 101 255）
        // MARK: - 系统组件
        private static let statusBarStyleDay          = UIStatusBarStyle.default              //状态栏
        private static let indicatorStyleDay          = UIActivityIndicatorView.Style.gray    //菊花
        // MARK: 浅色主题配色[END]<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        
        // MARK: 深色主题配色(夜晚)[START]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        // MARK: - 主色
        private static let hexPrimaryNight              = "#a565ff"     //主色（rgb 165 101 255）
        private static let hexAssistNight               = "#a2a7ae"     //辅助色（rgb 162 167 174）
        private static let hexAssistAlphaNight          = "#a2a7ae99" //辅助色（rgb 162 167 174) 60
        // MARK: - 背景色
        private static let hexForegroundNight           = "#272641"     //前景色（rgb 39 38 65）
        private static let hexBackgroundNight           = "#202136"     //背景色（rgb 32 33 54）
        private static let hexBackgroundHighNight       = "#3a3961"     //背景高亮色（rgb 58 57 97）
        private static let hexBackgroundAlphaNight      = "#3a39617f"   //背景高亮色（rgb 39 38 65 0.5）
        private static let hexTextBackgroundNight       = "#171828"     //输入文本背景色（rgb 23 24 40）
        private static let hexSeparatorNight            = "#393859"     //分割线（rgb 57 56 58）
        // MARK: - 文本
        private static let hexTitleNight                = "#ffffff"     //标题（rgb 255 255 255）
        private static let hexSubTitleNight             = "#ffffffcc"   //子标题（rgba 255 255 255, 0.8）
        private static let hexBodyNight                 = "#dcdcdc"     //正文（rgb 220 220 220）
        // MARK: - 弹框
        private static let hexPopBgNight                = "#272641"     //弹窗背景色（rgb 39 38 65）
        private static let hexPopBodyNight              = "#ffffff99"   //弹窗正文（rgba 255 255 255, 0.6）
        // MARK: - Tab栏
        private static let hexTabTintUnNight            = "#919aab"     //Tab栏标题未选中色（rgb 145 154 171）
        private static let hexTabTintSelectNight        = "#ef5db6"     //Tab栏标题选中色（rgb 239 93 182）
        // MARK: - 系统组件
        private static let statusBarStyleNight          = UIStatusBarStyle.lightContent         //状态栏
        private static let indicatorStyleNight          = UIActivityIndicatorView.Style.white   //菊花
        // MARK: 深色主题配色[END]<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        
        
        // MARK: 固定配色[START]********************************************************************************
        // MARK: - 背景色 ----------------------------------------------
        private static let hexErrorBg                   = "#f92770"     //错误/警告背景色（rgb 249 39 112）
        private static let hexBadgeBg                   = "#f92b70"     //未读提醒背景色（rgb 249 43 112）
        private static let hexTranslucentBg             = "#0000007f"   //半透明背景色（rgba 0 0 0, 0.5）
        private static let hexViewMask                  = "#0000004c"   //视图蒙层（rgba 0 0 0, 0.3）
        // MARK: - 文字 ----------------------------------------------
        private static let hexColorfulBgText            = "#ffffff"     //带背景色的文字颜色（rgb 255 255 255）
        // MARK: - 弹框 ----------------------------------------------
        private static let hexToastBg                   = "#0000007f"   //Toast景色（rgba 0 0 0, 0.5）
        // MARK: - 按钮 ------------------------------------------------
        
        private static let hexSecHeaderAct              = ["ffcb52", "ff7b02"]
        private static let hexSecHeaderSub              = ["c165dd", "5c27ee"]
        private static let hexSecHeaderTwe              = ["1fe4e3", "b488f7"]
        private static let hexSecHeaderCat              = ["7d9cf1", "1555fd"]
        private static let hexSecHeaderTod              = ["ffcb52", "ff7b02"]
        private static let hexSecHeaderLik              = ["fe568d", "e563ff"]
        private static let hexSecHeaderHot              = ["ffcb52", "ff7b02"]
        /// 扁平按钮背景色
        private static let hexsFlatBtnBgNor             = ["#c165dd", "#5c27fe"]        //扁平按钮背景色 - 正常状态
        private static let hexsFlatBtnBgAlpha           = ["#c165dd33", "#5c27fe33"]    //扁平按钮背景色 - 正常状态0.2透明度
        private static let hexsFlatBtnBgHigh            = ["#8f4ca4", "#481ec6"]        //扁平按钮背景色 - 按下状态
        private static let hexsFlatBtnBgDis             = ["#4c4a73", "#555473"]        //扁平按钮背景色 - 禁用状态
        /// 浅色扁平按钮背景色
        private static let hexsFlatBtnLightBgNor        = ["#c165dd7f", "#5c27fe7f"]    //浅色扁平按钮背景色 - 正常状态
        /// 带边框按钮背景色
        private static let hexsOutlineBtnBgNor          = ["#c165dd33", "#5c27fe33"]    //带边框按钮背景色 - 正常状态
        private static let hexsOutlineBtnBgHigh         = ["#8f4ca4", "#481ec6"]        //带边框按钮背景色 - 按下状态
        private static let hexsOutlineBtnBgDis          = ["#4c4a73", "#555473"]        //带边框按钮背景色 - 禁用状态
        /// 带边框按钮边线颜色
        private static let hexsOutlineBtnBorderNor      = ["#c165dd", "#5c27fe"]        //带边框按钮边线颜色 - 正常状态
        private static let hexsOutlineBtnBorderHigh     = ["#8f4ca4", "#481ec6"]        //带边框按钮边线颜色 - 按下状态
        private static let hexsOutlineBtnBorderDis      = ["#4c4a73", "#555473"]        //带边框按钮边线颜色 - 禁用状态
        /// 带背景色按钮文字颜色
        private static let hexColorfulBtnTitleNor       = "#ffffff"     //带背景色按钮文字颜色 - 正常状态（rgb 255 255 255）
        private static let hexColorfulBtnTitleHigh      = "#bdbdbd"     //带背景色按钮文字颜色 - 按下状态（rgb 189 189 189）
        private static let hexColorfulBtnTitleDis       = "#ffffff7f"   //带背景色按钮文字颜色 - 禁用状态（rgba 255 255 255, 0.5）
        /// 文本按钮文字颜色
        private static let hexTextBtnTitle              = "#a565ff"     //文本按钮文字颜色 - 正常状态（rgb 165 101 255）
        private static let hexTextBtnTitleHigh          = "#7a4bbd"     //文本按钮文字颜色 - 按下状态（rgb 127 75 189）
        private static let hexTextBtnTitleDis           = "#a565ff7f"   //文本按钮文字颜色 - 禁用状态（rgba 165 101 255, 0.5）
        /// 单选框背景色
        private static let hexRadioItemBgUn             = "#a565ff33"   //单选框背景色 - 未选中状态（rgb 255 255 255）
        private static let hexRadioItemBgAct            = "#a565ff80"   //单选框背景色 - 选中状态（rgb 189 189 189）
        /// 单选框边线颜色
        private static let hexRadioItemBorderUn         = "#a565ff80"   //单选框边线颜色 - 未选中状态（rgb 255 255 255）
        private static let hexRadioItemBorderAct        = "#a565ff"     //单选框边线颜色 - 选中状态（rgb 189 189 189）
        /// 转发按钮标题颜色
        private static let hexForwardBtnAct             = "#28e4ff"     //转发按钮标题颜色（rgb 40 228 255）
        // MARK: - 滑杆 ------------------------------------------------
        private static let hexSliderMaxTrack            = "#d8d8d833"   //滑杆 - 默认颜色（rgba 216 216 216, 0.2）
        private static let hexSliderMinTrack            = "#ffffffcc"   //滑杆 - 进度颜色（rgba 255 255 255, 0.8）
        private static let hexSliderBufferTrack         = "#00000099"   //滑杆 - 缓存进度颜色（rgba 0 0 0, 0.6）
        private static let hexProgressBufferTrack       = "#0101017f"   //视频进度 - 缓存进度颜色（rgba 1 1 1, 0.5）
        // MARK: - 订单 ------------------------------------------------
        private static let hexOrderSuccess              = "#5ffa5c"     //订单 - 成功（rgb 95 250 92）
        private static let hexOrderAmount               = "#fcc82b"     //订单 - 金额（rgb 252 200 43）
        // MARK: - 订阅详情 ---------------------------------------------
        private static let hexSubsInfoStatusBg          = "#7e31ec"     //订阅详情 - 状态背景色（rgb 126 49 236）
        private static let hexSubsInfoLevelBg           = "#352192"     //订阅详情 - 等级背景色（rgb 53 33 146）
        private static let hexSubsInfoTime              = "#c5bee0"     //订阅详情 - 时间（rgb 197 190 224）
        // 发推按钮进度圈颜色
        private static let hexPublishProgCircle         = "ef5db6"
        private static let hexPublishProgCircleTin      = "9797977f"
        // cd-key颜色
        private static let hexCdKeyTitle                = "#baaa8a"
        // 清除按钮背景色
        private static let hexclearButtonbg             = "#949cbd"
        // 账号登录按钮背景色
        private static let loginButtonbg                = "#3c68e3"
        // MARK: 固定配色[END]**********************************************************************************

        
        
        // MARK: - 随主题变换色 ======================================================================================

        // MARK: - 主色 ----------------------------------------------
        /// 主色
        static let theme_primary: ThemeColorPicker = [hexPrimaryDay, hexPrimaryNight]
        static let theme_primaryCG: ThemeCGColorPicker = [hexPrimaryDay, hexPrimaryNight]
        static var primary: UIColor { return !ThemeStyle.isNight() ? UIColor(hex: hexPrimaryDay) : UIColor(hex: hexPrimaryNight) }
        static var hexPrimary: String { return !ThemeStyle.isNight() ? hexPrimaryDay : hexPrimaryNight }

        /// 辅助色
        static let theme_assist: ThemeColorPicker = [hexAssistDay, hexAssistNight]
        static var assist: UIColor { return !ThemeStyle.isNight() ? UIColor(hex: hexAssistDay) : UIColor(hex: hexAssistNight) }
        static let assistValues = [hexAssistDay, hexAssistAlphaNight]
        
        static let assistAlphaNight: UIColor = UIColor(hex: hexAssistAlphaNight)
        // MARK: - 背景色 ---------------------------------------------
        /// 前景色
        static let theme_foreground: ThemeColorPicker = [hexForegroundDay, hexForegroundNight]
        static let theme_foregroundLayer: ThemeCGColorPicker = [hexForegroundDay, hexForegroundNight]
        static var foreground: UIColor { return !ThemeStyle.isNight() ? UIColor(hex: hexForegroundDay) : UIColor(hex: hexForegroundNight) }
        static func foreground(with alpha: CGFloat) -> UIColor { return !ThemeStyle.isNight() ? UIColor(hex: hexForegroundDay, alpha: alpha) : UIColor(hex: hexForegroundNight, alpha: alpha)}
        
        /// 背景色
        static let theme_background: ThemeColorPicker = [hexBackgroundDay, hexBackgroundNight]
        
        /// 背景高亮色
        static let theme_backgroundHigh: ThemeColorPicker = [hexBackgroundHighDay, hexBackgroundHighNight]
        
        /// 输入框背景色
        static let theme_textbackground: ThemeColorPicker = [hexBackgroundHighDay, hexTextBackgroundNight]
        
        /// 分割线
        static let theme_separator: ThemeColorPicker = [hexSeparatorDay, hexSeparatorNight]
        static let theme_separatorLayer: ThemeCGColorPicker = [hexSeparatorDay, hexSeparatorNight]
        static var separator: UIColor { return !ThemeStyle.isNight() ? UIColor(hex: hexSeparatorDay) : UIColor(hex: hexSeparatorNight) }
        static let separatorValues = [hexSeparatorDay, hexSeparatorNight]

        // MARK: - 文本 ----------------------------------------------
        /// 标题
        static let theme_title: ThemeColorPicker = [hexTitleDay, hexTitleNight]
        static var title: UIColor { return !ThemeStyle.isNight() ? UIColor(hex: hexTitleDay) : UIColor(hex: hexTitleNight) }
        static let titleValues = [hexTitleDay, hexTitleNight]
        
        /// 子标题
        static let theme_subTitleDay: ThemeColorPicker = [hexSubTitleDay, hexSubTitleNight]
        
        /// 正文
        static let theme_body: ThemeColorPicker = [hexBodyDay, hexBodyNight]
        
        // MARK: - 弹框 ----------------------------------------------
        /// 弹窗背景色
        static let theme_popBg: ThemeColorPicker = [hexPopBgDay, hexPopBgNight]
        static let theme_popBgCG: ThemeCGColorPicker = [hexPopBgDay, hexPopBgNight]
        
        /// 弹窗正文
        static let theme_hexPopBody: ThemeColorPicker = [hexPopBodyDay, hexPopBodyNight]

        // MARK: - Tab栏 ----------------------------------------------
        /// Tab栏 - 标题未选中色
        static let theme_tabTintUn: ThemeColorPicker = [hexTabTintUnDay, hexTabTintUnNight]
        static var tabTintUn: UIColor { return !ThemeStyle.isNight() ? UIColor(hex: hexTabTintUnDay) : UIColor(hex: hexTabTintUnNight) }
        
        /// Tab栏 - 标题选中颜色
        static let theme_tabTintSelect: ThemeColorPicker = [hexTabTintSelectDay, hexTabTintSelectNight]
        static var tabTintselect: UIColor { return !ThemeStyle.isNight() ? UIColor(hex: hexTabTintSelectDay) : UIColor(hex: hexTabTintSelectNight) }
        
        // MARK: - 系统组件 --------------------------------------------
        /// 状态栏
        static let theme_statusBarStyle: ThemeStatusBarStylePicker = [statusBarStyleDay, statusBarStyleNight]
        
        /// 菊花
        static let theme_indicatorStyle: ThemeActivityIndicatorViewStylePicker = [indicatorStyleDay, indicatorStyleNight]
        
        
        // MARK: - 固定色 ===========================================================================================

        // MARK: - 背景色 ----------------------------------------------
        /// 错误/警告背景色
        static let errorBg = UIColor(hex: hexErrorBg)
        /// 未读提醒背景色
        static let badgeBg = UIColor(hex: hexBadgeBg)
        /// 半透明背景色
        static let translucentBg = UIColor(hex: hexTranslucentBg)
        /// 视图蒙层
        static let viewMask = UIColor(hex: hexViewMask)
        
        // MARK: - 文字 ----------------------------------------------
        /// 带背景色的文字颜色
        static let colorfulBgText = UIColor(hex: hexColorfulBgText)
        
        /// 特定文字颜色
        static let colorPrimaryText = UIColor(hex: hexPrimaryDay)
        
        /// 提示文字颜色
        static let colorEmptyText = UIColor(hex: hexAssistDay)
        
        // MARK: - 弹框 ----------------------------------------------
        /// Toast背景色
        static let toastBg = UIColor(hex: hexToastBg)
        
        static var secHeaderAct: [CGColor] {
            return hexSecHeaderAct.compactMap{ return UIColor(hex: $0).cgColor }
        }
        
        static var secHeaderSub: [CGColor] {
            return hexSecHeaderSub.compactMap{ return UIColor(hex: $0).cgColor }
        }
        
        static var secHeaderTwe: [CGColor] {
            return hexSecHeaderTwe.compactMap{ return UIColor(hex: $0).cgColor }
        }
        
        static var secHeaderCat: [CGColor] {
            return hexSecHeaderCat.compactMap{ return UIColor(hex: $0).cgColor }
        }
        
        static var secHeaderTod: [CGColor] {
            return hexSecHeaderTod.compactMap{ return UIColor(hex: $0).cgColor }
        }
        
        static var secHeaderLik: [CGColor] {
            return hexSecHeaderLik.compactMap{ return UIColor(hex: $0).cgColor }
        }
        
        static var secHeaderHot: [CGColor] {
            return hexSecHeaderHot.compactMap{ return UIColor(hex: $0).cgColor }
        }
        // MARK: - 按钮 ------------------------------------------------
        /// 扁平按钮背景色 - 正常状态
        static var flatBtnBgNor: [CGColor] {
            return hexsFlatBtnBgNor.compactMap{ return UIColor(hex: $0).cgColor }
        }
        /// 扁平按钮背景色 - 正常状态0.2透明度
        static var flatBtnBgAlpha: [CGColor] {
            return hexsFlatBtnBgAlpha.compactMap{ return UIColor(hex: $0).cgColor }
        }
        /// 扁平按钮背景色 - 按下状态
        static var flatBtnBgHigh: [CGColor] {
            return hexsFlatBtnBgHigh.compactMap{ return UIColor(hex: $0).cgColor }
        }
        /// 扁平按钮背景色 - 禁用状态
        static var flatBtnBgDis: [CGColor] {
            return hexsFlatBtnBgDis.compactMap{ return UIColor(hex: $0).cgColor }
        }
        
        /// 浅色扁平按钮背景色 - 正常状态
        static var flatBtnLightBgNor: [CGColor] {
            return hexsFlatBtnLightBgNor.compactMap{ return UIColor(hex: $0).cgColor }
        }
        
        /// 带边框按钮背景色 - 正常状态
        static var outlineBtnBgNor: [CGColor] {
            return hexsOutlineBtnBgNor.compactMap{ return UIColor(hex: $0).cgColor }
        }
        /// 带边框按钮背景色 - 按下状态
        static var outlineBtnBgHigh: [CGColor] {
            return hexsOutlineBtnBgHigh.compactMap{ return UIColor(hex: $0).cgColor }
        }
        /// 带边框按钮背景色 - 禁用状态
        static var outlineBtnBgDis: [CGColor] {
            return hexsOutlineBtnBgDis.compactMap{ return UIColor(hex: $0).cgColor }
        }
        
        /// 带边框按钮边线颜色 - 正常状态
        static var outlineBtnBorderNor: [CGColor] {
            return hexsOutlineBtnBorderNor.compactMap{ return UIColor(hex: $0).cgColor }
        }
        /// 带边框按钮边线颜色- 按下状态
        static var outlineBtnBorderHigh: [CGColor] {
            return hexsOutlineBtnBorderHigh.compactMap{ return UIColor(hex: $0).cgColor }
        }
        /// 带边框按钮边线颜色 - 禁用状态
        static var outlineBtnBorderDis: [CGColor] {
            return hexsOutlineBtnBorderDis.compactMap{ return UIColor(hex: $0).cgColor }
        }
        
        /// 发推付费选择栏 半透明背景颜色
        static let backgroundAlphaNight = UIColor.init(white: 1.0, alpha: 0.5)//UIColor(hex: hexBackgroundAlphaNight)
        /// 带背景色按钮文字颜色 - 正常状态
        static let colorfulBtnTitleNor = UIColor(hex: hexColorfulBtnTitleNor)
        /// 带背景色按钮文字颜色 - 按下状态
        static let colorfulBtnTitleHigh = UIColor(hex: hexColorfulBtnTitleHigh)
        /// 带背景色按钮文字颜色 - 禁用状态
        static let colorfulBtnTitleDis = UIColor(hex: hexColorfulBtnTitleDis)
        
        /// 文本按钮文字颜色 - 正常状态
        static let textBtnTitle = UIColor(hex: hexTextBtnTitle)
        /// 文本按钮文字颜色 - 按下状态
        static let textBtnTitleHigh = UIColor(hex: hexTextBtnTitleHigh)
        /// 文本按钮文字颜色 - 禁用状态
        static let textBtnTitleDis = UIColor(hex: hexTextBtnTitleDis)
        
        /// 单选框背景色 - 正常状态
        static let radioItemBgUn = UIColor(hex: hexRadioItemBgUn)
        /// 单选框背景色 - 选中状态
        static let radioItemBgAct = UIColor(hex: hexRadioItemBgAct)
        
        /// 单选框边线颜色 - 正常状态
        static let radioItemBorderUn = UIColor(hex: hexRadioItemBorderUn)
        /// 单选框边线颜色 - 选中状态
        static let radioItemBorderAct = UIColor(hex: hexRadioItemBorderAct)
        
        /// 转发按钮标题颜色
        static let forwardBtnAct = UIColor(hex: hexForwardBtnAct)
        
        // MARK: - 滑杆 ------------------------------------------------
        /// 滑杆 - 默认颜色
        static let sliderMaxTrack = UIColor(hex: hexSliderMaxTrack)
        /// 滑杆 - 进度颜色
        static let sliderMinTrack = UIColor(hex: hexSliderMinTrack)
        /// 滑杆 - 缓存进度颜色
        static let sliderBufferTrack = UIColor(hex: hexSliderBufferTrack)
        /// 视频进度 - 缓存进度颜色
        static let progressBufferTrack = UIColor(hex: hexProgressBufferTrack)
        
        // MARK: - 订单 ------------------------------------------------
        /// 订单 - 成功
        static let orderSuccess = UIColor(hex: hexOrderSuccess)
        /// 订单 - 金额
        static let orderAmount = UIColor(hex: hexOrderAmount)
               
        // MARK: - 订阅详情 ---------------------------------------------
        /// 订阅详情 - 状态背景色
        static let subsInfoStatusBg = UIColor(hex: hexSubsInfoStatusBg)
        /// 订阅详情 - 等级背景色
        static let subsInfoLevelBg = UIColor(hex: hexSubsInfoLevelBg)
        /// 订阅详情 - 时间
        static let subsInfoTime = UIColor(hex: hexSubsInfoTime)
        /// 发推按钮进度圈颜色
        static let colorPubProgCircle = UIColor(hex: hexPublishProgCircle)
        static let colorPubProgCircleTin = UIColor(hex: hexPublishProgCircleTin)
        /// cd-key颜色
        static let colorCdKeyTitle = UIColor(hex: hexCdKeyTitle)
        /// tag颜色
        static let tagItemTitle = UIColor(hex: hexTabTintSelectDay)
        /// 清除按钮背景色
        static let colorClearButtonbg = UIColor(hex: hexclearButtonbg)
        // 账号登录按钮背景色
        static let colorLoginButtonbg = UIColor(hex: loginButtonbg)
        
        
    }
}
