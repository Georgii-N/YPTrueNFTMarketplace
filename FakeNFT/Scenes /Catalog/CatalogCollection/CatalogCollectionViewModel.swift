//
//  CatalogCollectionViewModel.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

final class CatalogCollectionViewModel: CatalogCollectionViewModelProtocol {
    
    // MARK: Private Dependencies:
    private var dataProvider: DataProviderProtocol?
    
    // MARK: - Observable Values:
    var collectionObservable: Observable<NFTCollection> {
        $collection
    }
    
    var nftsObservable: Observable<NFTCards?> {
        $nftCollection
    }
    
    var authorCollectionObservable: Observable<UserResponse?> {
        $authorCollection
    }
    
    @Observable
    private(set) var collection: NFTCollection
    
    @Observable
    private(set) var nftCollection: NFTCards?
    
    @Observable
    private(set) var authorCollection: UserResponse? {
        didSet {
            fetchNFTs()
        }
    }
    
    // MARK: - Lifecycle:
    init(collection: NFTCollection) {
        self.collection = collection
        self.dataProvider = DataProvider()
        fetchAuthor()
    }
    
    // MARK: Private Methods:
    private func fetchAuthor() {
        let authorID = collectionObservable.wrappedValue.author
        dataProvider?.fetchProfileId(userId: authorID, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let author):
                authorCollection = author
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func fetchNFTs() {
        guard let authorID = authorCollection?.id else { return }
        
        dataProvider?.fetchUsersNFT(userId: authorID, nftsId: collection.nfts, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.nftCollection = nfts
            case .failure(let error):
                print(error)
            }
        })
    }
}
