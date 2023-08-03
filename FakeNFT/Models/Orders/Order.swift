import Foundation

struct Order: Decodable {
    let nfts: [String]
    let id: String
}
