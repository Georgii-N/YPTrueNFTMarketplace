//
//  NFTCardViewModelProtocol.swift
//  FakeNFT
//
//  Created by Евгений on 02.08.2023.
//

import Foundation

protocol NFTCardViewModelProtocol: AnyObject {
    var currentNFT: NFTCell { get }
    var nftCollection: NFTCollection { get }
    var currenciesObservable: Observable<Currencies?> { get }
    var nftsObservable: Observable<[NFTCell]?> { get }
    var likeStatusDidChangeObservable: Observable<Bool> { get }
    var cartStatusDidChangeObservable: Observable<Bool> { get }
    func changeNFTFavouriteStatus(isLiked: Bool, id: String)
    func changeNFTCartStatus(isAddedToCart: Bool, id: String)
}
