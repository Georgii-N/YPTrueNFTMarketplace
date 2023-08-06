//
//  CatalogCollectionViewModelProtocol.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

protocol CatalogCollectionViewModelProtocol: AnyObject {
    var likedNFTID: [String]? { get }
    var collectionObservable: Observable<NFTCollection> { get }
    var nftsObservable: Observable<NFTCards?> { get }
    var authorCollectionObservable: Observable<UserResponse?> { get }
}
