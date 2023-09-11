import Foundation
import RxSwift

/// 弹框协议
protocol ShowAlertDelegate {
    /// 显示Loading
    func showLoader()
    /// 隐藏Loading
    func hideLoader()

    /// 显示Toast提示
    func showToast(_ text: String)
    
}

class BaseViewModel: TTViewModel {
    
    /// Alert Delegate
    public var showAlertDelegate: ShowAlertDelegate?

    /// 显示Loading
    func showLoader() {
        guard let showAlertDelegate = showAlertDelegate else {
            fatalError("Please set `showAlertDelegate`")
        }
        showAlertDelegate.showLoader()
    }
    
    /// 隐藏Loading
    func hideLoader() {
        guard let showAlertDelegate = showAlertDelegate else {
            fatalError("Please set `showAlertDelegate`")
        }
        showAlertDelegate.hideLoader()
    }

    /// 显示Toast提示
    func showToast(_ text: String) {
        guard let showAlertDelegate = showAlertDelegate else {
            fatalError("Please set `showAlertDelegate`")
        }
        return showAlertDelegate.showToast(text)
    }
    
    
    
    /// 分页页码
    public var pageNo: Int = APIPage.DefValue.pageNo.rawValue
    /// 分页是否有下一页
    public var hasNext: Bool = false
    /// 列表是否正在请求
    public var isListRequest: Bool = false
    
    public var pageSize: Int = 10
    /// 设置页面
    func setPageNo(_ isReqMore: Bool) {
        pageNo = isReqMore ? pageNo+1 : APIPage.DefValue.pageNo.rawValue
    }
    
    
    /// 接口请求服务
    public var apiService: APIService?
    
    let showAlertImpl = DefaultShowAlertImpl.shared
    
    ///  设置弹框代理
    func setupAlertDelegator(with viewModel: BaseViewModel) {
        showAlertImpl.setupAlertDelegator(width: viewModel)
    }
    
    private var progressContainer: [(Int, Progress)] = []
    
    func calculateProgress(index: Int, progress: Progress,
                                   itemCount: Int,
                                   successValue: CGFloat) -> CGFloat {

        if let firstIndex = progressContainer.firstIndex(where: { item in
            item.0 == index
        }) {
            progressContainer[firstIndex].1 = progress
        }else {
            progressContainer.append((index, progress))
        }
        debugPrint(progressContainer)
        var total: CGFloat = 0
        for item in progressContainer {
            let prog = item.1.fractionCompleted * successValue / CGFloat(itemCount)
            total = total + prog
        }
        
        return total
    }
}
