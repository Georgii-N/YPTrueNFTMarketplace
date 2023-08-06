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
    func fetchUsersRating(sortingOption: SortingOption, page: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        
        var queryItems = [URLQueryItem(name: "p", value: "\(page)"),
                          URLQueryItem(name: "l", value: "10")]
     
        switch sortingOption {
        case .byName:
            queryItems.append(contentsOf: [URLQueryItem(name: "sortBy", value: "name"),
                               URLQueryItem(name: "order", value: "asc")])
        default:
            break
        }
        
        let url = createURLWithPathAndQueryItems(path: Resources.Network.MockAPI.Paths.users,
                                                 queryItems: queryItems)
        
        let request = NetworkRequestModel(endpoint: url,
                                          httpMethod: .get,
                                          dto: nil)
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
    
    func fetchUsersNFT(userId: String?, nftsId: [String]?, completion: @escaping (Result<NFTCards, Error>) -> Void) {
        
        let queryItems = [URLQueryItem(name: "filter", value: userId)]
        let url = createURLWithPathAndQueryItems(path: Resources.Network.MockAPI.Paths.nftCard, queryItems: queryItems)
        
        let request = NetworkRequestModel(endpoint: url, httpMethod: .get)
        networkClient.send(request: request, type: NFTCards.self) { result in
            switch result {
            case .success(let result):
                var result = result
                if let userId {
                    result.filter { userId.contains($0.author) }
                }
                if let nftsId {
                    result.filter { nftsId.contains($0.id)}
                }
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCurrencies(completion: @escaping (Result<Currencies, Error>) -> Void) {
          
          let url = createURLWithPathAndQueryItems(path: Resources.Network.MockAPI.Paths.currencies, queryItems: nil)
          let request = NetworkRequestModel(endpoint: url, httpMethod: .get)
          networkClient.send(request: request, type: Currencies.self) { result in
              switch result {
              case .success(let currencies):
                  completion(.success(currencies))
              case .failure(let error):
                  completion(.failure(error))
              }
          }
      } 
}
