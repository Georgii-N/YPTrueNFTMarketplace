import Foundation

struct Currencie: Decodable {
    let title, name: String
    let image: String
    let id: String
}

typealias Currencies = [Currencie]
