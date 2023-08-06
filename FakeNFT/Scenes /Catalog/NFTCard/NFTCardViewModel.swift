//
//  NFTCardViewModel.swift
//  FakeNFT
//
//  Created by Евгений on 02.08.2023.
//

import Foundation

final class NFTCardViewModel: NFTCardViewModelProtocol {
    
    // MARK: Private Dependencies:
    private var dataProvider: DataProviderProtocol?
    
    // MARK: Observable Values:
    var currentNFTObservable: Observable<NFTCell> {
        $currentNFT
    }
    
    var nftCollectionObservable: Observable<NFTCollection> {
        $nftCollection
    }
    
    var currenciesObservable: Observable<Currencies?> {
        $currencies
    }
    
    var nftsObservable: Observable<[NFTCell]> {
        $nfts
    }
    
    @Observable
    private(set) var currentNFT: NFTCell
    
    @Observable
    private(set) var nftCollection: NFTCollection
    
    @Observable
    private(set) var currencies: Currencies?
    
    @Observable
    private(set) var nfts: [NFTCell]
    
    // MARK: - Lifecycle:
    init(nfts: [NFTCell], nftModel: NFTCell, nftCollection: NFTCollection) {
        self.currentNFT = nftModel
        self.nfts = nfts
        self.nftCollection = nftCollection
        self.dataProvider = DataProvider()
        fetchCurrencies()
    }

    // MARK: - Private func:
    private func fetchCurrencies() {
        dataProvider?.fetchCurrencies(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let currencies):
                self.currencies = currencies
            case .failure(let error):
                print(error)
            }
        })
    }
}
