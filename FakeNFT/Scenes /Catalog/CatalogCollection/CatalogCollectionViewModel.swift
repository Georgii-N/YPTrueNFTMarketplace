//
//  CatalogCollectionViewModel.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

final class CatalogCollectionViewModel: CatalogCollectionViewModelProtocol {
    // MARK: - Constants and Variables
    var coverNFTImage: UIImage?
    var nameOfNFTCollection = "Peach"
    var aboutAuthor = L10n.Catalog.CurrentCollection.author
    var author = "John Doe"
    var collectionInformation = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
    var aboutAuthorURLString = "https://practicum.yandex.ru/ios-developer/"
    func setCurrentNFTImage(image: UIImage) {
        coverNFTImage = image
        
    }
}
