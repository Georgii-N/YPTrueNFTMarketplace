//
//  CatalogCollectionViewModelProtocol.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

protocol CatalogCollectionViewModelProtocol: AnyObject {
    var profile: Profile? { get }
    var collectionObservable: Observable<NFTCollection> { get }
    var nftsObservable: Observable<[NFTCell]?> { get }
    var authorCollectionObservable: Observable<UserResponse?> { get }
    var likeStatusDidChangeObservable: Observable<Bool> { get }
    func changeNFTFavouriteStatus(isLiked: Bool, id: String)
}
