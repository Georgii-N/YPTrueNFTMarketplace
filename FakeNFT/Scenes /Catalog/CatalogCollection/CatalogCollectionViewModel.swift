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
    var profile: Profile?
    
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
    
    var likeStatusDidChangeObservable: Observable<Bool> {
        $likeStatusDidChange
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
    
    @Observable
    private(set) var likeStatusDidChange = false
    
    // MARK: - Lifecycle:
    init(collection: NFTCollection) {
        self.collection = collection
        self.dataProvider = DataProvider()
        fetchProfile()
        fetchAuthor()
    }
    
    // MARK: Public Methods:
    func changeNFTFavouriteStatus(isLiked: Bool, id: String) {
        guard var newLikes = profile?.likes else { return }
        
        if !isLiked {
            newLikes.append(id)
        } else {
            guard let index = newLikes.firstIndex(where: { $0 == id }) else { return }
            newLikes.remove(at: index)
        }
        
        guard var profile = profile else { return }
        profile = Profile(name: profile.name,
                          avatar: profile.avatar,
                          description: profile.description,
                          website: profile.website,
                          nfts: profile.nfts,
                          likes: newLikes,
                          id: profile.id)
        
        dataProvider?.putNewProfile(profile: profile, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.likeStatusDidChange = true
                self.profile = profile
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // MARK: - Private Methods:
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
                self.profile = profile
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
                    let isLiked = self.profile?.likes.contains($0.id)
                    return NFTCell(name: $0.name,
                                   images: $0.images,
                                   rating: $0.rating,
                                   price: $0.price,
                                   author: $0.author,
                                   id: $0.id,
                                   isLiked: isLiked ?? false,
                                   isAddedToCard: false)
                })
            case .failure(let error):
                print(error)
            }
        }
    }
}
