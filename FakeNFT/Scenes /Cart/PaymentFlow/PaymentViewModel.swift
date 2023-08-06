//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Даниил Крашенинников on 06.08.2023.
//

import Foundation

final class PaymentViewModel {
    
    private let dataProvider = DataProvider()
    
    @Observable
    private(set) var currencieNFT: [Currencie] = []
    
    init() {
        getData()
    }
    
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
}
