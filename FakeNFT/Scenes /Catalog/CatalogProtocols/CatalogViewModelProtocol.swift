//
//  CatalogViewModelProtocol.swift
//  FakeNFT
//
//  Created by Евгений on 31.07.2023.
//

import UIKit

protocol CatalogViewModelProtocol: AnyObject {
    var mockImages: [UIImage?] { get }
    var mockLabels: [String] { get }
}
