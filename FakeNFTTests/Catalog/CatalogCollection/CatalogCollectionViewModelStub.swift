//
//  CatalogCollectionViewModelStub.swift
//  FakeNFTTests
//
//  Created by Евгений on 22.08.2023.
//

@testable import FakeNFT

final class CatalogCollectionViewModelStub: CatalogCollectionViewModelProtocol {
    
    // MARK: - Public Dependencies:
    var provider: FakeNFT.DataProviderProtocol
    
    // MARK: - Observable Values:
    var collectionObservable: FakeNFT.Observable<FakeNFT.NFTCollection> {
        $collection
    }
    
    var nftsObservable: FakeNFT.Observable<[FakeNFT.NFTCell]?> {
        $nftCollection
    }
    
    var authorCollectionObservable: FakeNFT.Observable<FakeNFT.UserResponse?> {
        $authorCollection
    }
    
    var likeStatusDidChangeObservable: FakeNFT.Observable<Bool> {
        $likeStatusDidChange
    }
    
    var cartStatusDidChangeObservable: FakeNFT.Observable<Bool> {
        $cartStatusDidChange
    }
    
    var networkErrorObservable: FakeNFT.Observable<String?> {
        $networkError
    }
    
    @Observable
    private(set) var collection: NFTCollection
    
    @Observable
    private(set) var nftCollection: [NFTCell]?
    
    @Observable
    private(set) var authorCollection: UserResponse?
    
    @Observable
    private(set) var likeStatusDidChange = false
    
    @Observable
    private(set) var cartStatusDidChange = false
    
    @Observable
    private(set) var networkError: String?
    
    init(dataProvider: DataProviderProtocol, collection: NFTCollection) {
        self.provider = dataProvider
        self.collection = collection
    }
    
    func changeNFTFavouriteStatus(isLiked: Bool, id: String) {
        
    }
    
    func changeNFTCartStatus(isAddedToCart: Bool, id: String) {
        
    }
    
    func updateNFTCardModels() {
        provider.fetchUsersNFT(userId: nil, nftsId: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nftCards):
                self.nftCollection = nftCards.map({
                    return NFTCell(name: $0.name,
                                   images: $0.images,
                                   rating: $0.rating,
                                   price: $0.price,
                                   author: $0.author,
                                   id: $0.id,
                                   isLiked: true,
                                   isAddedToCard: true)
                })
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        }
    }
}
