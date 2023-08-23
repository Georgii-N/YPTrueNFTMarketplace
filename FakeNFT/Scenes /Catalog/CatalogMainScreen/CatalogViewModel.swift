//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import Foundation

final class CatalogViewModel: CatalogViewModelProtocol {
    
    // MARK: - Private Dependencies:
    private var dataProvider: DataProviderProtocol
    
    // MARK: - Private Classes:
    private let userDefaultService = UserDefaultsService.shared
    private let analyticsService = AnalyticsService.instance
    
    // MARK: - Constants and Variables:
    var provider: DataProviderProtocol {
        dataProvider
    }
    
    // MARK: - Observable Values:
    var nftCollectionsObservable: Observable<NFTCollections?> {
        $nftCollections
    }
    
    var networkErrorObservable: Observable<String?> {
        $networkError
    }
    
    @Observable
    private(set) var nftCollections: NFTCollections?
    
    @Observable
    private(set) var networkError: String?
    
    // MARK: - Lifecycle:
    init(dataProvider: DataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    // MARK: Public Methods:
    func sortNFTCollection(option: SortingOption, newCollection: [NFTCollection]?) {
        if newCollection == nil {
            guard let nftCollections else { return }
            var collection = NFTCollections()
            
            switch option {
            case .byTitle:
                collection = returnSortedCollection(option: .byTitle, collection: nftCollections)
            case .byQuantity:
                collection = returnSortedCollection(option: .byQuantity, collection: nftCollections)
            default:
                collection = returnSortedCollection(option: .close, collection: nftCollections)
            }
            
            userDefaultService.saveSortingOption(option, forScreen: .catalog)
            self.nftCollections = collection
        } else {
            let option = userDefaultService.getSortingOption(for: .catalog) ?? .close
            self.nftCollections = returnSortedCollection(option: option, collection: newCollection ?? [])
        }
    }
    
    func fetchCollections() {
        dataProvider.fetchNFTCollection { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let collections):
                self.sortNFTCollection(option: .close, newCollection: collections)
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        }
    }
    
    // MARK: - Private Methods:
    private func returnSortedCollection(option: SortingOption, collection: NFTCollections) -> NFTCollections {
        var newCollection = NFTCollections()

        switch option {
        case .byTitle:
            newCollection = collection.sorted(by: { $0.name < $1.name })
            analyticsService.sentEvent(screen: .catalogMain, item: .buttonSortingByTitle, event: .click)
        case .byQuantity:
            newCollection = collection.sorted(by: { $0.nfts.count > $1.nfts.count })
            analyticsService.sentEvent(screen: .catalogMain, item: .buttonSortingByNumber, event: .click)
        default:
            newCollection = collection
        }
        
        return newCollection
    }
}
