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
        let request = networkRequestModel(endpoint: url, httpMethod: .get, dto: nil)
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
}
