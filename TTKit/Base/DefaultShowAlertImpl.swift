/// ShowAlert Delegate默认实现
class DefaultShowAlertImpl: ShowAlertDelegate {
    
    static let shared = DefaultShowAlertImpl()

    ///  设置弹框代理
    func setupAlertDelegator(width viewModel: BaseViewModel) {
        viewModel.showAlertDelegate = self
    }
    
    /// 显示Loading
    func showLoader() {
        TTProgressHUD.show(nil, inView: TTRouter.shared.currentView())
    }
    
    /// 隐藏Loading
    func hideLoader() {
        TTProgressHUD.hide(TTRouter.shared.currentView())
    }
    
    /// 显示Toast提示
    func showToast(_ text: String) {
        TToast.show(text, success: nil)
    }
}
