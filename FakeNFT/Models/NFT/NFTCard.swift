import Foundation

struct NFTCard: Decodable {
    let createdAt: Date
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author, id: String
}

typealias NFTCards = [NFTCard]
