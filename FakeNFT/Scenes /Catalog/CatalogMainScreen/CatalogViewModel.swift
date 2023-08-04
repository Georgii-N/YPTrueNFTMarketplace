//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

final class CatalogViewModel: CatalogViewModelProtocol {
    
    // MARK: - Public Dependencies:
    var dataProvider: DataProviderProtocol?
    
    // MARK: - Observable Values:
    var nftCollectionsObservable: Observable<NFTCollections?> {
        $nftCollections
    }

    @Observable
    private(set) var nftCollections: NFTCollections?
        
    // MARK: - Lifecycle:
    init(dataProvider: DataProviderProtocol?) {
        self.dataProvider = dataProvider
        fetchCollections()
    }
    
    // MARK: - Private Methods:
    private func fetchCollections() {
        dataProvider?.fetchNFTCollection(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let collections):
                self.nftCollections = collections
            case .failure(let error):
                print(error)
            }
        })
    }
}
