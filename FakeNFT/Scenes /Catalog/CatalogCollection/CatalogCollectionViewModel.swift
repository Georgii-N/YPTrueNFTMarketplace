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
    
    // MARK: Constants and Variables:
    var likedNFTID: [String]?
    
    // MARK: - Observable Values:
    var collectionObservable: Observable<NFTCollection> {
        $collection
    }
    
    var nftsObservable: Observable<[NFTCell]?> {
        $nftCollection
    }
    
    var authorCollectionObservable: Observable<UserResponse?> {
        $authorCollection
    }
    
    @Observable
    private(set) var collection: NFTCollection
    
    @Observable
    private(set) var nftCollection: [NFTCell]?
    
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
        fetchProfile()
        fetchAuthor()
    }
    
    // MARK: Private Methods:
    private func fetchAuthor() {
        let authorID = collectionObservable.wrappedValue.author
        dataProvider?.fetchUserID(userId: authorID, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let author):
                authorCollection = author
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func fetchProfile() {
        dataProvider?.fetchProfile(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                let arrayID = profile.likes.map({ $0 })
                self.likedNFTID = arrayID
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func fetchNFTs() {
        guard let authorID = authorCollection?.id else { return }
        
        dataProvider?.fetchUsersNFT(userId: authorID, nftsId: collection.nfts) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                nftCollection = nfts.map({
                    let isLiked = self.likedNFTID?.contains($0.id)
                    return NFTCell(name: $0.name,
                                   images: $0.images,
                                   rating: $0.rating,
                                   price: $0.price,
                                   author: $0.author,
                                   id: $0.id,
                                   isLiked: isLiked,
                                   isAddedToCard: false)
                })
            case .failure(let error):
                print(error)
            }
        }
    }
}
