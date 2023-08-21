import UIKit
#if canImport(ESPullToRefresh)
import ESPullToRefresh
#endif

extension UIScrollView {
    
    /// 添加下拉刷新
    @discardableResult
    public func headerRefresh(_ handler: @escaping (() -> ())) -> UIScrollView {
        #if canImport(ESPullToRefresh)
        let headerAnimator = AwesomeRefreshHeaderAnimator.init(frame: CGRect.zero)
        headerAnimator.indicatorStyle = TTKitConfiguration.PullToRefresh.indicatorStyle
        
        self.es.addPullToRefresh(animator: headerAnimator, handler: handler)

        #endif
        
        return self
    }
    
    /// 添加上拉加载更多
    @discardableResult
    public func footerLoadMore(_ handler: @escaping (() -> ())) -> UIScrollView {
        #if canImport(ESPullToRefresh)
        let footerAnimator = AwesomeRefreshFooterAnimator.init(frame: CGRect.zero)
        footerAnimator.indicatorStyle = TTKitConfiguration.PullToRefresh.indicatorStyle
        
        self.es.addInfiniteScrolling(animator: footerAnimator, handler: handler)
        #endif
        
        return self
    }
    
    /// 移除下拉刷新
    public func headerRefreshRemove() {
        #if canImport(ESPullToRefresh)
        self.es.removeRefreshHeader()
        #endif
    }
    
    /// 移除上拉加载更多
    public func footerLoadMoreRemove() {
        #if canImport(ESPullToRefresh)
        self.es.removeRefreshFooter()
        #endif
    }
    
    /// 停止下拉刷新
    public func headerEndRefreshing() {
        #if canImport(ESPullToRefresh)
        mainQueueExecuting { [weak self] in
            self?.es.stopPullToRefresh()
        }
        #endif
    }
    
    /// 停止上拉加载更多
    public func footerEndLoadingMore() {
        #if canImport(ESPullToRefresh)
        mainQueueExecuting { [weak self] in
            self?.es.stopLoadingMore()
        }
        #endif
    }
    
    /// 手动触发下拉刷新
    public func startHeaderRefreshing(_ seconds: Double = 0.0) {
        #if canImport(ESPullToRefresh)
        delayExecuting(seconds, inMain: true) { [weak self] in
            self?.es.startPullToRefresh()
        }
        #endif
    }
    
    /// 过期自动刷新
    public func autoRefreshWhenExpired(_ refreshIdentifier: String, expiredTimeInterval: TimeInterval = 30) {
        #if canImport(ESPullToRefresh)
        self.refreshIdentifier = refreshIdentifier
        self.expiredTimeInterval = expiredTimeInterval
        
        delayExecuting(1.0, inMain: true) { [weak self] in
            self?.es.autoPullToRefresh()
        }
        #endif
    }
}
