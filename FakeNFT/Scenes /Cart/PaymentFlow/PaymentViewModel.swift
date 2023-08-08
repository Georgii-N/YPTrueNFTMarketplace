
import Foundation

protocol PaymentViewModelProtocol: AnyObject {
    var currencieID: Int? {get set}
    var currencieNfts: Observable<[Currencie]?> {get}
    func makePay(completion: @escaping (Bool) -> Void)
    func unwrappedPaymentViewModel() -> [Currencie]
}

final class PaymentViewModel: PaymentViewModelProtocol {
    
    // MARK: Constants
    private let dataProvider = DataProvider()
    
    // MARK: Observable constants and variables
    @Observable
    private(set) var currencieNFT: [Currencie]? = []
    
    //MARK: Dependencies
    var currencieID: Int?
    
    var currencieNfts: Observable<[Currencie]?> {
        $currencieNFT
    }
    
    // MARK: Init
    init() {
        getData()
    }
    
    // MARK: Methods
   private func getData () {
        dataProvider.fetchCurrencies {result in
            switch result {
            case .success(let currencie):
                self.currencieNFT?.append(contentsOf: currencie)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
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
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func unwrappedPaymentViewModel() -> [Currencie] {
       let currencieNFT: [Currencie] = []
       if let currencieNFT = self.currencieNfts.wrappedValue {
           return currencieNFT
       }
       return currencieNFT
   }
}
