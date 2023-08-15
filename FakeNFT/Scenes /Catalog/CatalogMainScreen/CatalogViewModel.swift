//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

final class CatalogViewModel: CatalogViewModelProtocol {
    
    // MARK: - Private Dependencies:
    private var dataProvider: DataProviderProtocol
    
    // MARK: - Private Classes:
    private let userDefaultService = UserDefaultsService.shared
    
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
    func sortNFTCollection(option: SortingOption) {
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
        
        userDefaultService.saveSortingOption(option, forScreen: .catalog)
        self.nftCollections = collection
    }
    
    func fetchCollections() {
        dataProvider.fetchNFTCollection { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let collections):
                self.networkError = nil
                self.nftCollections = collections
                if let option = self.userDefaultService.getSortingOption(for: .catalog) {
                    self.sortNFTCollection(option: option)
                }
            case .failure(let error):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: error)
                self.networkError = errorString
            }
        }
    }
}
