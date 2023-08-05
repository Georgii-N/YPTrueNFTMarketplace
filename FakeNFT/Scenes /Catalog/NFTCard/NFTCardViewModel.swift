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
    var currentNFTObservable: Observable<NFTCard> {
        $currentNFT
    }
    
    var nftCollectionObservable: Observable<NFTCollection> {
        $nftCollection
    }
    
    var currenciesObservable: Observable<Currencies?> {
        $currencies
    }
    
    var nftsObservable: Observable<NFTCards> {
        $nfts
    }
    
    @Observable
    private(set) var currentNFT: NFTCard 
    
    @Observable
    private(set) var nftCollection: NFTCollection
    
    @Observable
    private(set) var currencies: Currencies?
    
    @Observable
    private(set) var nfts: NFTCards
    
    // MARK: - Lifecycle:
    init(nfts: NFTCards, nftModel: NFTCard, nftCollection: NFTCollection) {
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
