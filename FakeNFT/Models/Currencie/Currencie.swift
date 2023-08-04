import Foundation

struct Currencie: Decodable {
    let title: String
    let name: String
    let image: String
    let id: String
}

typealias Currencies = [Currencie]
