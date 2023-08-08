//
//  NFTCardViewModel.swift
//  FakeNFT
//
//  Created by Евгений on 02.08.2023.
//

import Foundation

final class NFTCardViewModel: NFTCardViewModelProtocol {
    
    // MARK: - Private Dependencies:
    private var dataProvider: DataProviderProtocol?
    
    // MARK: - Constants and Variables:
    var currentNFT: NFTCell
    var nftCollection: NFTCollection
    var authorCollection: UserResponse? {
        didSet {
            fetchNFTs()
        }
    }
    
    private var profile: Profile?
    private var order: Order?
    
    // MARK: - Observable Values:
    var currenciesObservable: Observable<Currencies?> {
        $currencies
    }
    
    var nftsObservable: Observable<[NFTCell]?> {
        $nfts
    }
    
    var likeStatusDidChangeObservable: Observable<Bool> {
        $likeStatusDidChange
    }
    
    var cartStatusDidChangeObservable: Observable<Bool> {
        $cartStatusDidChange
    }
    
    @Observable
    private(set) var currencies: Currencies?
    
    @Observable
    private(set) var nfts: [NFTCell]?
    
    @Observable
    private(set) var likeStatusDidChange = false
    
    @Observable
    private(set) var cartStatusDidChange = false
    
    // MARK: - Lifecycle:
    init(nftModel: NFTCell, nftCollection: NFTCollection) {
        self.currentNFT = nftModel
        self.nftCollection = nftCollection
        self.dataProvider = DataProvider()
        fetchAuthor()
        fetchProfile()
        fetchOrder()
        fetchCurrencies()
    }

    // MARK: - Public Methods:
    func fetchCurrencies() {
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
    
    func changeNFTCartStatus(isAddedToCart: Bool, id: String) {
        guard var newOrderID = order?.nfts else { return }
        
        if !isAddedToCart {
            newOrderID.append(id)
        } else {
            guard let index = newOrderID.firstIndex(where: { $0 == id }) else { return }
            newOrderID.remove(at: index)
        }
        
        guard var order = order else { return }
        order = Order(nfts: newOrderID, id: "1")
        
        dataProvider?.putNewOrder(order: order, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.cartStatusDidChange = true
                self.order = order
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func updateNFTCardModels() {
        fetchProfile()
        fetchOrder()
        fetchAuthor()
    }
 
    // MARK: - Private func:
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
    
    private func fetchOrder() {
        dataProvider?.fetchOrder(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.order = order
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func fetchAuthor() {
        let authorID = nftCollection.author
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
    
    private func fetchNFTs() {
        guard let authorID = authorCollection?.id else { return }
        
        dataProvider?.fetchUsersNFT(userId: authorID, nftsId: nftCollection.nfts) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.nfts = nfts.map({
                    let isLiked = self.profile?.likes.contains($0.id)
                    let isAddedToCart = self.order?.nfts.contains($0.id)
                    return NFTCell(name: $0.name,
                                   images: $0.images,
                                   rating: $0.rating,
                                   price: $0.price,
                                   author: $0.author,
                                   id: $0.id,
                                   isLiked: isLiked ?? false,
                                   isAddedToCard: isAddedToCart ?? false)
                })
            case .failure(let error):
                print(error)
            }
        }
    }
}
