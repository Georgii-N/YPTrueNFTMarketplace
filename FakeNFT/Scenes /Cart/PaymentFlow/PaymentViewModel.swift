//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Даниил Крашенинников on 06.08.2023.
//

import Foundation

final class PaymentViewModel {
    
    // MARK: Constants
    private let dataProvider = DataProvider()
    
    // MARK: Observable constants and variables
    @Observable
    private(set) var currencieNFT: [Currencie] = []
    
    // MARK:  Dependencies
    var currencieID: Int?
    
    // MARK: Init
    init() {
        getData()
    }
    
    // MARK: Methods
    func getData () {
        dataProvider.fetchCurrencies {result in
            switch result {
            case .success(let currencie):
                self.currencieNFT.append(contentsOf: currencie)
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
}
