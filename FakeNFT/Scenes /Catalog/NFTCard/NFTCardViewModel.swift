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
    private var currentNFT: NFTCell
    private var nftCollection: NFTCollection
    private var authorCollection: UserResponse? {
        didSet {
            fetchNFTs()
        }
    }
    
    private var profile: Profile?
    private var order: Order?
    
    private var tokenPaths = [
        Resources.Network.NFTBrowser.bitcoin, Resources.Network.NFTBrowser.dogecoin,
        Resources.Network.NFTBrowser.tether, Resources.Network.NFTBrowser.apecoin,
        Resources.Network.NFTBrowser.solana, Resources.Network.NFTBrowser.ethereum,
        Resources.Network.NFTBrowser.cordano, Resources.Network.NFTBrowser.shibainu
    ]
    
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
    
    var networkErrorObservable: Observable<String?> {
        $networkError
    }
    
    @Observable
    private(set) var currencies: Currencies?
    
    @Observable
    private(set) var nfts: [NFTCell]?
    
    @Observable
    private(set) var likeStatusDidChange = false
    
    @Observable
    private(set) var cartStatusDidChange = false
    
    @Observable
    private(set) var networkError: String?
    
    // MARK: - Lifecycle:
    init(dataProvider: DataProviderProtocol, nftModel: NFTCell, nftCollection: NFTCollection) {
        self.dataProvider = dataProvider
        self.currentNFT = nftModel
        self.nftCollection = nftCollection
    }
    
    // MARK: - Public Methods:
    // Network
    func updateNFTCardModels() {
        fetchProfile()
        fetchCurrencies()
    }
    
    func changeNFTFavouriteStatus(isLiked: Bool, id: String) {
        guard var newLikes = profile?.likes else { return }
        
        if !isLiked {
            newLikes.append(id)
        } else {
            guard let index = newLikes.firstIndex(where: { $0 == id }) else { return }
            newLikes.remove(at: index)
        }
        
        guard var profile else { return }
        profile = Profile(name: profile.name,
                          avatar: profile.avatar,
                          description: profile.description,
                          website: profile.website,
                          nfts: profile.nfts,
                          likes: newLikes,
                          id: profile.id)
        
        dataProvider?.putNewProfile(profile: profile) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.likeStatusDidChange = true
                self.profile = profile
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
                self.networkError = nil
            }
        }
    }
    
    func changeNFTCartStatus(isAddedToCart: Bool, id: String) {
        guard var newOrderID = order?.nfts else { return }
        
        if !isAddedToCart {
            newOrderID.append(id)
        } else {
            guard let index = newOrderID.firstIndex(where: { $0 == id }) else { return }
            newOrderID.remove(at: index)
        }
        
        guard var order else { return }
        order = Order(nfts: newOrderID, id: "1")
        
        dataProvider?.putNewOrder(order: order) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.cartStatusDidChange = true
                self.order = order
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
                self.networkError = nil
            }
        }
    }
    
    // Actions with info:
    func getCurrentNFTModel() -> NFTCell {
        currentNFT
    }
    
    func getNFTCollection() -> NFTCollection {
        nftCollection
    }
    
    func getAuthorCollection() -> UserResponse {
        authorCollection ?? UserResponse(name: "",
                                         avatar: "",
                                         description: "",
                                         website: "",
                                         nfts: [],
                                         rating: "",
                                         id: "")
    }
    
    func getNFTWebPath(index: Int) -> String? {
        tokenPaths[index]
    }
    
    func setNewCurrentModel(isLike: Bool) {
        let isLiked = isLike ? !currentNFT.isLiked: currentNFT.isLiked
        let isAddedToCart = isLike ? currentNFT.isAddedToCard : !currentNFT.isAddedToCard
        
        let newModel = NFTCell(name: currentNFT.name,
                               images: currentNFT.images,
                               rating: currentNFT.rating,
                               price: currentNFT.price,
                               author: currentNFT.author,
                               id: currentNFT.id,
                               isLiked: isLiked,
                               isAddedToCard: isAddedToCart)
        currentNFT = newModel
    }
    
    // MARK: - Private func:
    private func fetchProfile() {
        dataProvider?.fetchProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                self.fetchOrder()
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
                self.networkError = nil
            }
        }
    }
    
    private func fetchOrder() {
        dataProvider?.fetchOrder { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let order):
                self.order = order
                self.fetchAuthor()
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        }
    }
    
    private func fetchAuthor() {
        let authorID = nftCollection.author
        dataProvider?.fetchUserID(userId: authorID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let author):
                authorCollection = author
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        }
    }
    
    private func fetchNFTs() {
        guard let authorID = authorCollection?.id else { return }
        
        dataProvider?.fetchUsersNFT(userId: authorID, nftsId: nftCollection.nfts) { [weak self] result in
            guard let self else { return }
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
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        }
    }
    
    private func fetchCurrencies() {
        dataProvider?.fetchCurrencies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let currencies):
                self.currencies = currencies
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        }
    }
}
