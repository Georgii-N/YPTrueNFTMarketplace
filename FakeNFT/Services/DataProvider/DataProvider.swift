import Foundation

final class DataProvider: DataProviderProtocol {
    
    // MARK: - Private classes
    let networkClient = DefaultNetworkClient()
    
    // MARK: - Private Functions
    private func createURLWithPathAndQueryItems(path: String, queryItems: [URLQueryItem]?) -> URL? {
        let baseUrlString = Resources.Network.MockAPI.defaultStringURL
        
        guard var components = URLComponents(string: baseUrlString) else {
            return nil
        }
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
    
    // MARK: - Public Functions
    func fetchUsersRating(completion: @escaping (Result<[User], Error>) -> Void) {
        
        let url = createURLWithPathAndQueryItems(path: Resources.Network.MockAPI.Paths.users, queryItems: nil)
        let request = NetworkRequestModel(endpoint: url, httpMethod: .get, dto: nil)
        networkClient.send(request: request, type: UsersResponse.self) { result in
            switch result {
            case .success(let usersResponse):
                let users = usersResponse.map { $0.convert() }
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchProfileId(userId: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        
        let path = Resources.Network.MockAPI.Paths.users + "/\(userId)"
        let url = createURLWithPathAndQueryItems(path: path, queryItems: nil)
        let request = NetworkRequestModel(endpoint: url, httpMethod: .get)
        networkClient.send(request: request, type: UserResponse.self) { result in
            
            switch result {
            case .success(let profileId):
                
                completion(.success(profileId))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUsersNFT(userId: String, nftsId: [Int]?, completion: @escaping (Result<NFTCards, Error>) -> Void) {
        
        let queryItems = [URLQueryItem(name: "filter", value: userId)]
        let url = createURLWithPathAndQueryItems(path: Resources.Network.MockAPI.Paths.nftCard, queryItems: queryItems)
        
        let request = NetworkRequestModel(endpoint: url, httpMethod: .get)
        networkClient.send(request: request, type: NFTCards.self) { result in
            switch result {
            case .success(let result):
                var result = result.filter { userId.contains($0.author) }
                if let nftsId {
                    result = result.filter { nftsId.contains(Int($0.id) ?? 0)}
                }
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
