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
    private(set) var cartNFT: [NFTCard] = []
    
    init() {
        getData()
    }
    
    func getData () {
        idNfts.forEach {dataProvider.fetchNFTs(nftId: $0) { result in
            switch result {
            case .success(let data):
                data.forEach{ self.cartNFT.append($0)}
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
          }
        }
    }
    
    func additionNFT() -> Int {
        return cartNFT.count
    }
    
    func additionPriceNFT() -> Float {
        Float(cartNFT.reduce(0) {$0 + $1.price})
    }
    
}
