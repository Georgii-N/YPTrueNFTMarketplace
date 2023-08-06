//
//  NFTCardViewModelProtocol.swift
//  FakeNFT
//
//  Created by Евгений on 02.08.2023.
//

import Foundation

protocol NFTCardViewModelProtocol: AnyObject {
    var currentNFTObservable: Observable<NFTCell> { get }
    var nftCollectionObservable: Observable<NFTCollection> { get }
    var currenciesObservable: Observable<Currencies?> { get }
    var nftsObservable: Observable<[NFTCell]> { get }
}
