//
//  CatalogCollectionViewModel.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

final class CatalogCollectionViewModel: CatalogCollectionViewModelProtocol {
    
    var dataProvider: DataProviderProtocol?
    
    // MARK: - Observable Values:
    var collectionObservable: Observable<NFTCollection> {
        return $collection
    }
    
    var nftCollectionObservable: Observable<NFTCards?> {
        $nftCollection
    }
    
    var authorCollectionObservable: Observable<String?> {
        $authorCollection
    }
    
    @Observable
    private(set) var collection: NFTCollection
    
    @Observable
    private(set) var nftCollection: NFTCards?
    
    @Observable
    private(set) var authorCollection: String?
    
    // MARK: - Constants and Variables
    var coverNFTImage: UIImage?
    var nameOfNFTCollection = "Peach"
    var aboutAuthor = L10n.Catalog.CurrentCollection.author
    var collectionInformation = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
    var aboutAuthorURLString = "https://practicum.yandex.ru/ios-developer/"
    func setCurrentNFTImage(image: UIImage) {
        coverNFTImage = image
    }
    
    init(collection: NFTCollection) {
        self.collection = collection
        self.dataProvider = DataProvider()
    }
    
    func fetchNFT() {
        let nftsID = collectionObservable.wrappedValue.nfts
        dataProvider?.fetchUsersNFT(userName: "Cole Edwards", nftsId: [], completion: { result in
            switch result {
            case .success(let nfts):
                print(nfts)
            case .failure(let error):
                print(error)
            }
        })
    }
}
