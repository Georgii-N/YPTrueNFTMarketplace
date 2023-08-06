//
//  NFTCollectionCellDelegate.swift
//  FakeNFT
//
//  Created by Евгений on 06.08.2023.
//

import Foundation

protocol NFTCollectionCellDelegate: AnyObject {
    func likeButtonDidTapped(cell: NFTCollectionCell)
}
