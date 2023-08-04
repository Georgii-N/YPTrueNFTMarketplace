import Foundation

protocol DataProviderProtocol {
    func fetchUsersRating(completion: @escaping (Result<[User], Error>) -> Void)
    
    func fetchProfileId(userId: String, completion: @escaping (Result<UserResponse, Error>) -> Void)
}
