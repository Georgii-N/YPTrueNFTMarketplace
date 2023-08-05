import Foundation

protocol DataProviderProtocol {
    func fetchUsersRating(completion: @escaping (Result<[User], Error>) -> Void)
    func fetchProfileId(userId: String, completion: @escaping (Result<UserResponse, Error>) -> Void)
    func fetchUsersNFT(userId: String, nftsId: [String]?, completion: @escaping (Result<NFTCards, Error>) -> Void)
    func fetchCurrencies(completion: @escaping (Result<Currencies, Error>) -> Void)
}
