//
//  ModelCartNFT.swift
//  FakeNFT
//
//  Created by Даниил Крашенинников on 02.08.2023.
//

import Foundation

struct ModelCartNFT: Decodable {
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    let id: String
    
}

struct ModelCartNFTRespone: Decodable {
      let createdAt: String
        let name: String
        let images: [String]
        let rating: Int
        let description: String
        let price: Float
        let author: String
        let id: String
    
//    enum CodingKeys: String, CodingKey {
//
//        case createdAt = "createdAt"
//        case name = "name"
//        case images = "images"
//        case rating = "rating"
//        case description = "description"
//        case price = "price"
//        case author = "author"
//        case id = "id"
//
//    }
    
    func convert() -> ModelCartNFT {
        return ModelCartNFT(name: self.name, images: self.images, rating: self.rating, price: self.price, id: self.id)
    }
}

struct CurrenciesNFT: Decodable {
    let title: String
    let name: String
    let image: String
    let id: String
    
//    enum CodingKeys: String, CodingKey {
//    
//        case title = "title"
//        case name = "name"
//        case image = "image"
//        case id = "id"
//
//    }
}
