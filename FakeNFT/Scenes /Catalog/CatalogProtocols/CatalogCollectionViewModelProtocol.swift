//
//  CatalogCollectionViewModelProtocol.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

protocol CatalogCollectionViewModelProtocol: AnyObject {
    var coverNFTImage: UIImage? { get }
    var nameOfNFTCollection: String { get }
    var aboutAuthor: String { get }
    var author: String { get }
    var collectionInformation: String { get }
    func setCurrentNFTImage(image: UIImage)
}
