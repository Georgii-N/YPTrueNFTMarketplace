import Foundation

protocol PaymentViewModelProtocol: AnyObject {
    var currencieID: Int? {get set}
    var currencieNfts: Observable<[Currency]?> {get}
    var networkErrorObservable: Observable<String?> {get}
    func makePay(completion: @escaping (Bool) -> Void)
    func unwrappedPaymentViewModel() -> [Currency]
}

final class PaymentViewModel: PaymentViewModelProtocol {
    
    // MARK: Constants
    private let dataProvider = DataProvider()
    
    // MARK: Observable constants and variables
    @Observable
    private(set) var currencieNFT: [Currency]? = []
    
    @Observable
        private(set) var networkError: String?
    
    // MARK: Dependencies
    var currencieID: Int?
    
    var currencieNfts: Observable<[Currency]?> {
        $currencieNFT
    }
    
    var networkErrorObservable: Observable<String?> {
            $networkError
        }
    
    // MARK: Init
    init() {
        getData()
    }
    
    // MARK: Methods
   private func getData () {
       dataProvider.fetchCurrencies {[weak self] result in
           guard let self = self else { return }
            switch result {
            case .success(let currencie):
                self.currencieNFT?.append(contentsOf: currencie)
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        }
    }
    
    func makePay(completion: @escaping (Bool) -> Void) {
        guard let id = currencieID else { return }
        dataProvider.fetchPaymentCurrency(currencyId: id) { result in
            switch result {
            case .success(let data):
                completion(data.success)
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        }
    }
    
    func unwrappedPaymentViewModel() -> [Currency] {
       let currencieNFT: [Currency] = []
       if let currencieNFT = self.currencieNfts.wrappedValue {
           return currencieNFT
       }
       return currencieNFT
   }
}
