//
//  NFTCell.swift
//  FakeNFT
//
//  Created by Евгений on 06.08.2023.
//

import Foundation

struct NFTCell {
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
    let author: String
    let id: String
    let isLiked: Bool?
    let isAddedToCard: Bool?
}

typealias NFTCells = [NFTCell]
