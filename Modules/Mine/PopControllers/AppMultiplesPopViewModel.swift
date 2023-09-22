import RxSwift

class AppMultiplesPopViewModel: BaseViewModel {

    let rx_didCreateFamilyTapped = PublishSubject<String>()
    let rx_didSexSelectedTapped = PublishSubject<(Int, String)>()
    let rx_didDateSelectedTapped = PublishSubject<String>()
//    let rx_didAddressSelectedTapped = PublishSubject<AddressSelected>()
    let rx_didPermissionSelectedTapped = PublishSubject<(Int, String)>()
    let rx_didLongGongSelectedTapped = PublishSubject<Int>()
    let rx_didMenuDeleteButtonTapped = PublishSubject<Void>()
    let rx_didMenuReportButtonTapped = PublishSubject<Void>()
    let rx_didForwardShequButtonTapped = PublishSubject<Void>()
    let rx_didForwardQinyouButtonTapped = PublishSubject<Void>()
    let rx_didForwardWeixinButtonTapped = PublishSubject<Void>()
    
//    var images: [ImageListItemModel] = []
//    let rx_didBGImageSelected = PublishSubject<ImageItemModel>()
}
