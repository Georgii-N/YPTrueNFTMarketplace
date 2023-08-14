//
//  NFTCardViewControllerDelegate.swift
//  FakeNFT
//
//  Created by Евгений on 07.08.2023.
//

import Foundation

protocol NFTCardViewControllerDelegate: AnyObject {
    func addIndexToUpdateCell(index: IndexPath, isLike: Bool)
    func addIndexToUpdateCell(index: IndexPath, isAddedToCart: Bool)
}
