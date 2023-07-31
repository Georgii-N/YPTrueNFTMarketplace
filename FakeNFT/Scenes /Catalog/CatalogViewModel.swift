//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

final class CatalogViewModel: CatalogViewModelProtocol {
    var mockImages = [
        UIImage(named: "Frame 9430"), UIImage(named: "Frame 9431"),
        UIImage(named: "Frame 9432"), UIImage(named: "Frame 9433")]
    
    var mockLabels = [
        "Peach (11)", "Blue (6)", "Brown (8)", "Yellow (9)"
    ]
}
