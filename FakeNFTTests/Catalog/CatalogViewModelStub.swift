//
//  CatalogViewModelStub.swift
//  FakeNFTTests
//
//  Created by Евгений on 21.08.2023.
//

@testable import FakeNFT
import UIKit

final class CatalogViewModelStub: CatalogViewModelProtocol {
    
    var provider: FakeNFT.DataProviderProtocol
    
    var nftCollectionsObservable: FakeNFT.Observable<FakeNFT.NFTCollections?> {
        $nftCollections
    }
    
    var networkErrorObservable: FakeNFT.Observable<String?> {
        $networkError
    }
    
    @Observable
    private(set) var nftCollections: NFTCollections?
    
    @Observable
    private(set) var networkError: String?
    
    init(provider: DataProviderProtocol) {
        self.provider = provider
    }
    func sortNFTCollection(option: FakeNFT.SortingOption) {
        guard let nftCollections else { return }
        
        var collection = NFTCollections()
        switch option {
        case .byTitle:
            collection = nftCollections.sorted(by: { $0.name < $1.name })
        case .byQuantity:
            collection = nftCollections.sorted(by: { $0.nfts.count > $1.nfts.count })
        default:
            break
        }
        
        self.nftCollections = collection
    }
    
    func fetchCollections() {
        provider.fetchNFTCollection { result in
            switch result {
            case .success(let collection):
                self.nftCollections = collection
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        }
    }
}
