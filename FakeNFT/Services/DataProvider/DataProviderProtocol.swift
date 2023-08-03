import Foundation

protocol DataProviderProtocol {
    func fetchUsersRating(completion: @escaping (Result<[User], Error>) -> Void)
    func fetchNFTCollection(completion: @escaping (Result<NFTCollections, Error>) -> Void)
}
