import Foundation

protocol DataProviderProtocol {
    func fetchUsersRating(completion: @escaping (Result<[User], Error>) -> Void)
}
