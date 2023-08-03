//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

final class CatalogViewModel: CatalogViewModelProtocol {
    
    var dataProvider: DataProviderProtocol?
    
    var nftCollectionsObservable: Observable<NFTCollections?> {
        $nftCollections
    }
    
    @Observable
    private(set) var nftCollections: NFTCollections?
    
    var mockImages = [
        UIImage(named: "Frame 9430"), UIImage(named: "Frame 9431"),
        UIImage(named: "Frame 9432"), UIImage(named: "Frame 9433")]
    
    var mockLabels = [
        "Peach (11)", "Blue (6)", "Brown (8)", "Yellow (9)"
    ]
    
    init(dataProvider: DataProviderProtocol?) {
        self.dataProvider = dataProvider
        fetchCollections()
    }
    
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
