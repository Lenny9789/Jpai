import UIKit

/// 数据加载动作
public enum FetchAction {
    /// 默认，不显示任何动画
    case none
    /// 后台请求，不显示动画
    case background
    /// 活动指示器动画
    case indicator
    /// Progress HUD动画
    case loading
    /// 下拉刷新动画
    case pullDown
    /// 上拉加载更多动画
    case pullUp
    /// 搜索
    case search(String)
    /// 骨骼动画
    case lottie
    
    public var isNone: Bool {
        switch self {
        case .none: return true
        case .background: return false
        case .indicator: return false
        case .loading: return false
        case .pullDown: return false
        case .pullUp: return false
        case .search(_): return false
        case .lottie: return false
        }
    }
    
    public var isBackground: Bool {
        switch self {
        case .none: return false
        case .background: return true
        case .indicator: return false
        case .loading: return false
        case .pullDown: return false
        case .pullUp: return false
        case .search(_): return false
        case .lottie: return false
        }
    }
    
    public var isIndicator: Bool {
        switch self {
        case .none: return false
        case .background: return false
        case .indicator: return true
        case .loading: return false
        case .pullDown: return false
        case .pullUp: return false
        case .search(_): return false
        case .lottie: return false
        }
    }
    
    public var isLoading: Bool {
        switch self {
        case .none: return false
        case .background: return false
        case .indicator: return false
        case .loading: return true
        case .pullDown: return false
        case .pullUp: return false
        case .search(_): return false
        case .lottie: return false
        }
    }
    
    public var isPullDown: Bool {
        switch self {
        case .none: return false
        case .background: return false
        case .indicator: return false
        case .loading: return false
        case .pullDown: return true
        case .pullUp: return false
        case .search(_): return false
        case .lottie: return false
        }
    }
    
    public var isPullUp: Bool {
        switch self {
        case .none: return false
        case .background: return false
        case .indicator: return false
        case .loading: return false
        case .pullDown: return false
        case .pullUp: return true
        case .search(_): return false
        case .lottie: return false
        }
    }
    
    public var isSearch: Bool {
        switch self {
        case .none: return false
        case .background: return false
        case .indicator: return false
        case .loading: return false
        case .pullDown: return false
        case .pullUp: return false
        case .search(_): return true
        case .lottie: return false
        }
    }
    
    public var isLottie: Bool {
        switch self {
        case .none: return false
        case .background: return false
        case .indicator: return false
        case .loading: return false
        case .pullDown: return false
        case .pullUp: return false
        case .search(_): return false
        case .lottie: return true
        }
    }
}


/// 列表加载数据处理便捷方法
///
extension UIScrollView {

    /// 界面开始加载数据
    public func beginLoading(_ action: FetchAction, inView: UIView? = nil) {
        if action.isIndicator {
            self.indicatorView.startAnimating()
        } else if action.isLoading {
            TTProgressHUD.show(nil, inView: inView ?? (self.superview ?? self))
        } else if action.isSearch {
            self.indicatorView.startAnimating()
        }
    }
    
    /// 界面结束加载数据
    public func endLoading(_ action: FetchAction, inView: UIView? = nil) {
        if action.isIndicator {
            self.indicatorView.stopAnimating()
        } else if action.isLoading {
            TTProgressHUD.hide(inView ?? (self.superview ?? self))
        } else if action.isPullDown {
            self.headerEndRefreshing()
        } else if action.isPullUp {
            self.footerEndLoadingMore()
        } else if action.isSearch {
            self.indicatorView.stopAnimating()
        }
    }
}
