import Foundation

struct NFTCollection: Decodable {
    let createdAt: Date
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}

typealias NFTCollections = [NFTCollection]
