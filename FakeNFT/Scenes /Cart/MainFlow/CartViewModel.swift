//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Даниил Крашенинников on 02.08.2023.
//

import Foundation

final class CartViewModel {
    
    private let dataProvider = DataProvider()
    private let idNfts: [Int] = [1, 2, 3]
    
    @Observable
    private(set) var cartNFT: [ModelCartNFT] = []
    
    init() {
        getData()
    }
    
    func getData () {
//        dataProvider.fetchCartList {result in
//            switch result {
//            case .success(let data):
//               // data.forEach {self.cartNFT.append($0)}
//                print("----------------------\(self.cartNFT)")
//            case .failure(let error):
//                assertionFailure(error.localizedDescription)
//            }
//        }
//        
//        dataProvider.fetchCurrencies {result in
//            switch result {
//            case .success(let data):
//               // data.forEach {self.cartNFT.append($0)}
//                print("----------------------\(self.cartNFT)")
//            case .failure(let error):
//                assertionFailure(error.localizedDescription)
//            }
//        }
        
        idNfts.forEach {dataProvider.fetchNFTs(nftId: $0) { result in
            switch result {
            case .success(let data):
               // data.forEach {self.cartNFT.append($0)}
               data.forEach{self.cartNFT.append($0)}
                print("----------------------\(self.cartNFT)")
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
        }
        
//        dataProvider.fetchNFTs(nftId: 1) { result in
//            switch result {
//            case .success(let data):
//               // data.forEach {self.cartNFT.append($0)}
//               data.forEach{self.cartNFT.append($0)}
//                print("----------------------\(self.cartNFT)")
//            case .failure(let error):
//                assertionFailure(error.localizedDescription)
//            }
//        }
    }
    
}
